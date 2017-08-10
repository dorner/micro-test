module AwsHelper
  class << self

    # Needs to be called from within a mktmpdir block.
    # @param s3_key [String]
    # @param temp_dir [String]
    # @param bucket [String]
    # @return [String] the downloaded file path.
    def download_from_s3(s3_key, temp_dir, bucket='wishabiflyerfiles')
      client = Aws::S3::Client.new
      filename = File.basename(s3_key)
      client.get_object(
              response_target: "#{temp_dir}/#{filename}",
              bucket: bucket,
              key: s3_key
      )
      "#{temp_dir}/#{filename}"
    end

    # Get the number of messages in queue and messages running for the SQS
    # queue.
    # @return [Hash<Symbol, Integer>]
    def get_queue_attributes
      attributes = %w(ApproximateNumberOfMessages ApproximateNumberOfMessagesNotVisible)
      client = Aws::SQS::Client.new
      url = client.get_queue_url(
        queue_name: ENV['SQS_QUEUE_NAME']
      ).queue_url
      attributes = client.get_queue_attributes(
        queue_url: url,
        attribute_names: attributes).attributes
      {
        in_queue: attributes['ApproximateNumberOfMessages'],
        running: attributes['ApproximateNumberOfMessagesNotVisible']
      }
    end
  end
end
