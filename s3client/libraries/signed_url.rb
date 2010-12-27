begin
  Gem.clear_paths
  require 'aws/s3'
rescue LoadError
  Chef::Log.debug("Missing gem 'aws/s3'")
end

module S3
  module File
    def self.signed_url(bucket,
                      object_name,
                      aws_access_key_id,
                      aws_secret_access_key)

      @@s3 ||= ::AWS::S3
      @@s3::Base.establish_connection! :access_key_id => aws_access_key_id,
                                     :secret_access_key => aws_secret_access_key

      url = @@s3::S3Object.url_for(object_name, bucket, :use_ssl => true)
      Chef::Log.info "signed_url[#{bucket}/#{object_name}]: generated signed 5 minute S3 url #{url}"
      url
   end
  end
end
