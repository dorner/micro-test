# A model that represents a job that has been sent off the worker app.
class StoredJob < ApplicationRecord
  include Concerns::Truncation
  enum state: {
    not_run: 1,
    queued: 2,
    finished: 3,
    error: 4
  }

  serialize :results, Hash
  serialize :options, Hash

  before_create :_globalize_options

  truncates :error_message, :error_backtrace

  # Use if you have an external worker configured.
  def self.external?
    false
  end

  # @return [Symbol]
  def self.queue_name
    (self.external? ? ENV['OUTGOING_QUEUE_NAME'] : ENV['SQS_QUEUE_NAME'])&.to_sym
  end

  # @return [Integer]
  def self.max_retries
    1
  end

  # http://stackoverflow.com/questions/4113479/dynamic-class-definition-with-a-class-name
  # @return [Class < ActiveJob::Base]
  def self.job_class
    return @job_class if @job_class
    klass = self
    class_name = klass.name.demodulize
    return @job_class if @job_class
    @job_class = Class.new(ApplicationJob)
    Object.const_set(class_name, @job_class)
    @job_class.stored_job_class = self
    @job_class.class_eval do
      queue_as klass.queue_name

      def perform(job_id, options={})
        self.stored_job_class.find(job_id).perform(options)
      end
    end
    @job_class
  end

  # Actual logic for the job.
  # @param options [Hash]
  # @return [String] the results to save into the job.
  def run_job(options={})
    raise NotImplementedError
  end

  def perform(options={})
    self.finished_at = Time.zone.now
    begin
      results = run_job(options)
      self.results = results
      self.state = 'finished'
    rescue => e
      self.error_message = e.message
      self.error_backtrace = e.backtrace.join("\n")
      self.state = 'error'
    end

    if self.error? && self.retries < self.class.max_retries
      self.retries += 1
      self.queue_job
    else
      self.save!
    end
  end

  # Queue up a job with the given options, and save the queued job to the
  # database as well.
  # @param options [Hash] the options to send off to the job.
  def self.enqueue(options={})
    job_obj = self.new(options)
    job_obj.save!
    job_obj.queue_job
  end

  # @return [Boolean] True if this job's options are already serialized
  def serialized?
    !!@serialized
  end

  # Queue up the job.
  def queue_job
    begin
      self.created_at = Time.zone.now
      self.state = :queued
      self.error_message = nil
      self.error_backtrace = nil
      self.results = nil
      queue_options = self.options.dup
      if self.persisted? || self.serialized?
        ApplicationRecord.deglobalize_instances(queue_options)
      end
      self.save!
      self.class.job_class.perform_later(self.id, queue_options)
    rescue => e
      self.state = 'error'
      self.error_message = "Error enqueuing job: #{e.message}"
      self.error_backtrace = e.backtrace.join("\n")
      self.save!
    end
  end

  # Set up the options to send to the queued job. Default is to use what
  # was passed in.
  # @param options [Hash].
  def self.queue_options(options={})
    options
  end

  # Filter the list of stored jobs by options.
  # @param options [Hash]
  #   * job_id [Integer]
  #   * state [Integer|Symbol]
  #   * job_type [String]
  #   * date_from [String]
  #   * date_to [String]
  # @return [Array<StoredJob>]
  def self.filter(options={})

    if options[:job_id].present?
      return [StoredJob.find(options[:job_id])]
    end

    query = StoredJob.all

    if options[:state].present?
      query = query.where(state: options[:state].to_sym)
    end

    if options[:job_type].present?
      query = query.where(type: options[:job_type])
    end

    if options[:date_from].present?
      date = options[:date_from]
      date = Date.parse(date) if date.is_a?(String)
      query = query.where('stored_jobs.updated_at >= ?', date)
    end
    if options[:date_to].present?
      date = options[:date_to]
      date = Date.parse(date) if date.is_a?(String)
      query = query.where('stored_jobs.updated_at <= ?', date)
    end

    query.order('updated_at DESC').paginate(per_page: 100, page: options[:page])
  end

  # @return [String]
  def self.display_name
    self.name.demodulize.titleize.gsub(/ Job/, '')
  end

  # @return [Hash<String, String>]
  def self.job_types_for_display
    Hash[self.descendants.map { |d| [d.display_name, d.name]}]
  end

  private

  # Maps the option hash to GlobalID URIs if necessary.
  def _globalize_options
    ApplicationRecord.globalize_instances(self.options)
  end

end

Dir["#{Rails.root}/app/models/jobs/*.rb"].each { |f| require f }

# load job classes for internal jobs
StoredJob.descendants.each { |k| k.job_class }
