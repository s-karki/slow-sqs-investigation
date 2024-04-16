require 'aws-sdk-sqs'
require 'dotenv'

Dotenv.load

Aws.config.update({
  region: ENV['AWS_REGION']
})

# Create an SQS client
Aws::SQS::Client.add_plugin(Aws::Plugins::UserAgent)
sqs = Aws::SQS::Client.new

# Specify the URL of the SQS queue
queue_url = ENV['QUEUE_URL']

def log_time(op_name, &block)
  start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
  return_value = block.call
  end_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)

  puts "executed #{op_name} in #{end_time - start_time} seconds"
  return_value
end

# Continuous message consumption loop
loop do
  begin
    response = log_time("receive") do
      sqs.receive_message({
        queue_url: queue_url,
        wait_time_seconds: 10
      })
    end

    if response.messages.any?
      response.messages.each do |message|
        # puts "Received message: #{message.id}"

        log_time("delete") do
          sqs.delete_message({
            queue_url:,
            receipt_handle: message.receipt_handle
          })
        end

        # puts "Deleted message #{message.id} from the queue"
      end
    else
      puts "No messages available in the queue"
    end
  rescue StandardError => e
    puts "Error receiving message: #{e.message}"
  end
end
