require 'active_job/logging'
class JsonLogFormatter < ::Logger::Formatter
  include ActiveSupport::TaggedLogging::Formatter
  def call(severity, timestamp, _, msg)
    tags = current_tags
    hash = {
      hostname: ::Socket.gethostname,
      severity: severity,
      timestamp: timestamp
    }
    request_id = tags[0]
    if request_id == 'ActiveJob'
      request_id = nil
      (job_class, job_id, client_info) = tags[1..3]
    else
      (job_class, job_id, client_info) = tags[2..4]
    end
    hash[:request_id] = request_id if request_id
    hash[:job_class] = job_class if job_class
    hash[:job_id] = job_id if job_id
    hash[:client_info] = client_info if client_info
    if msg.is_a?(Hash)
      hash.merge!(msg)
    else
      hash['message'] = msg
    end

    "#{hash.to_json}\n"
  end
end

class JsonLogSubscriber < ActiveJob::Logging::LogSubscriber
  def enqueue(event)
    info do
      job = event.payload[:job]
      {
        message:    'Enqueued job',
        queue_name: job.queue_name,
        job_class:  job.class.name,
        job_id:     job.job_id,
        arguments:  args_info(job)
      }
    end
  end

  def enqueue_at(event)
    info do
      job = event.payload[:job]
      {
        message:    'Enqueued job in future',
        queue_name: job.queue_name,
        job_class:  job.class.name,
        job_id:     job.job_id,
        queue_time: scheduled_at(event),
        arguments:  args_info(job)
      }
    end
  end

  def perform_start(event)
    info do
      job = event.payload[:job]
      {
        message:    'Performing job',
        queue_name: job.queue_name,
        job_class:  job.class.name,
        job_id:     job.job_id,
        arguments:  args_info(job)
      }
    end
  end

  def perform(event)
    info do
      job = event.payload[:job]
      {
        message:    'Performed job',
        queue_name: job.queue_name,
        job_class:  job.class.name,
        job_id:     job.job_id,
        arguments:  args_info(job),
        duration: event.duration.round(2)
      }
    end
  end

  def args_info(job)
    job.arguments.map { |arg| format(arg).inspect }.join(', ')
  end

end

ActiveJob::Base.logger.formatter = JsonLogFormatter.new
%w(perform enqueue enqueue_at perform_start).each do |method|
  ActiveSupport::Notifications.unsubscribe("#{method}.active_job")
end
JsonLogSubscriber.attach_to :active_job
