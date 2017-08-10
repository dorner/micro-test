require 'csv'
class SqsDownloader
  # Download all messages in a queue to a local CSV. Useful to look at a dead
  # letter queue.
  # Note that this will set the visibility timeout to 2 minutes, meaning
  # you will not be able to run this again within 2 minutes of running it.
  # This will also add another receive to the receive count of the job.
  # @param queue_name [String]
  # @param output_file [String]
  def self.download_queue(queue_name: "EcomDeadLetterQueue-production-DeadLetter",
                     output_file: "/tmp/queue.csv")
    config = Rails.application.config.active_elastic_job
    client = Aws::SQS::Client.new(region: config.aws_region,
                                  credentials: config.aws_credentials)
    queue_url = client.get_queue_url(
      queue_name: queue_name
    ).queue_url

    all_messages = []

    loop do
      result = client.receive_message(
        {
          queue_url: queue_url,
          attribute_names: ['All'],
          max_number_of_messages: 10,
          message_attribute_names: ['All'],
          visibility_timeout: 120,
        })
      break if result.messages.empty?
      puts "Received #{result.messages.size} messages, total #{all_messages.size}"
      all_messages.concat(result.messages)
    end

    CSV.open(output_file, 'w+') do |csv|
      csv << ['Message ID', 'Job Class', 'Job ID', 'Arguments', 'Digest', 'Sent']
      all_messages.each do |m|
        begin
          body = JSON.parse(m.body)
        rescue
          body = { body: m.body,
                   attributes: m.message_attributes.map { |k, v| "#{k}: #{v.string_value}"}
          }
        end
        csv << [
          m.message_id,
          body['job_class'],
          body['job_id'],
          body['arguments'] ?
            JSON.pretty_generate(body['arguments']) :
            JSON.pretty_generate(body),
          m.message_attributes['message-digest']&.string_value,
          DateTime.strptime("#{m.attributes['SentTimestamp'].to_i / 1000}", '%s').in_time_zone
        ]
      end
    end
    nil
  end

end