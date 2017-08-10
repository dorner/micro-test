# For instrumenting the app with datadog trace gem ddtrace
# The Rails integration will trace requests, database calls,
# templates rendering and cache read/write/delete operations.
# The integration makes use of the Active Support Instrumentation,
# listening to the Notification API so that any operation instrumented by the API is traced.

if !Rails.env.development? && !Rails.env.test?
  require 'ddtrace'
  ENV['USE_DATADOG'] = '1'
  Rails.configuration.datadog_trace = {
      auto_instrument: true,
      auto_instrument_redis: false,
      default_service: "test-app-#{Rails.env}",
      env: Rails.env
  }
end
