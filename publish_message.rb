require 'aws-sdk-sqs'
require 'securerandom'
require 'dotenv'

Dotenv.load

Aws.config.update({
  region: ENV['AWS_REGION']
})

client = Aws::SQS::Client.new
queue_url = ENV['QUEUE_URL']

num_messages = 100000
batch_size = 10


(num_messages / batch_size).times do |i|
  entries = Array.new(batch_size).map do
    {
      id: SecureRandom.uuid,
      message_body: SecureRandom.hex(4096)
    }
  end

  response = client.send_message_batch({
    queue_url:,
    entries:
  })

  response.successful.each do |success|
    puts "Message sent successfully: #{success.id}"
  end
end
