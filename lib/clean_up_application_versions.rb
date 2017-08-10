require 'aws-sdk'

APP_NAME = 'test-app'
region = 'us-east-1'

VERSIONS_TO_KEEP = 10
TIME_TO_KEEP = 1.week.ago

credentials =  Aws::SharedCredentials.new
client = Aws::ElasticBeanstalk::Client.new(credentials: credentials, region: region)
environments = client.describe_environments(
                       application_name: APP_NAME
).environments
deployed_versions = environments.map(&:version_label).uniq

versions = client.describe_application_versions(
                      application_name: APP_NAME
).application_versions

versions_to_delete = []

versions.each do |version|
  puts "Looking at version #{version.version_label}, date is #{version.date_updated.strftime("%Y-%m-%d %H:%M:%S")}"
  if version.date_updated < TIME_TO_KEEP &&
    !deployed_versions.include?(version.version_label)
      versions_to_delete << version
  end
end

# need at least X versions even if they are old
i = 0
versions_to_delete.delete_if do |version|
  if version.version_label =~ /production/ && i < VERSIONS_TO_KEEP
    i += 1
    true
  else
    false
  end
end

versions_to_delete.each do |version|
  puts "Deleting version #{version.version_label}"
  client.delete_application_version(
        application_name: APP_NAME,
        delete_source_bundle: true,
        version_label: version.version_label
  )
end
