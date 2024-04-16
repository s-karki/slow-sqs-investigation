require 'aws-sdk-sqs'
require 'dotenv'
require 'benchmark'


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
    Benchmark.bm do |x|
      responses = []

      x.report(:receive) do
        responses = sqs.receive_message({
          queue_url: queue_url,
          wait_time_seconds: 10
        })
      end

      if responses.messages.any?
        x.report(:delete) do
          responses.messages.each do |message|
            sqs.delete_message({
              queue_url:,
              receipt_handle: message.receipt_handle
            })
          end
        end
      else
        puts "No messages available in the queue"

      end
    end
  rescue StandardError => e
    puts "Error receiving message: #{e.message}"
  end
end
