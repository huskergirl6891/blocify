# Store the environment variables on the Rails.configuration object
 Rails.configuration.aws = {
   aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
   aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
   aws_region: ENV['AWS_REGION']
 }
