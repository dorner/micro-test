
# Use whatever backend for job processing you like.

class ApplicationJob < ActiveJob::Base


  around_perform do |job, block|
    tags = job.logger.formatter.current_tags
    request_id = tags[0]
    if request_id == 'ActiveJob'
      request_id = nil
      (job_class, job_id, client_info) = tags[1..3]
    else
      (job_class, job_id, client_info) = tags[2..4]
    end
    Thread.current[:job_info] = {
      request_id: request_id,
      job_class: job_class,
      job_id: job_id,
      client_info: client_info
    }
    if ENV['USE_DATADOG']
      Datadog.tracer.trace('activejob.perform') do |span|
        span.service = 'test-app-worker'
        span.set_tag('env', Rails.env)
        span.resource = job.class.name.demodulize
        block.call
      end
    else
      block.call
    end
  end

  # Log a message including the current job's class and arguments.
  # @param message [String|Hash]
  # @param level [Integer]
  def log_message(message, level=::Logger::INFO)
    tag_logger(self.class.name, self.job_id, '') do
      msg = if message.is_a?(String)
              { message: 'message' }
            elsif message.is_a?(Exception)
              level = ::Logger::ERROR
              { message: message.message, backtrace: message.backtrace.join("\n") }
            else
              message
            end
      self.logger.add(level, msg.merge(arguments: self.arguments))
    end
  end

  rescue_from(StandardError) do |exception|
    self.log_message(
      {
        message: exception.message,
        exception_class: exception.class.name,
        backtrace: exception.backtrace.join("\n")
      }, ::Logger::ERROR)
    raise
  end

end
