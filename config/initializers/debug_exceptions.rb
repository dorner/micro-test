# Change the exception logging so it does one line with newlines
# instead of a separate JSON log per line.
module ActionDispatch
  class DebugExceptions
    def log_error(request, wrapper)
      logger = logger(request)
      return unless logger

      exception = wrapper.exception

      trace = wrapper.application_trace
      trace = wrapper.framework_trace if trace.empty?

      ActiveSupport::Deprecation.silence do
        code = exception.try(:annoted_source_code) || []
        logger.fatal("#{exception.class} (#{exception.message}): #{code.join("\n")} #{trace.join("\n")}")
      end
    end
  end
end
