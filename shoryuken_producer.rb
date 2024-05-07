require "./shoryuken_consumer"
require "securerandom"

num_jobs = 20

num_jobs.times do |i|
  puts "running job #{i}"
  random_uuid = SecureRandom.uuid
  ShoryukenConsumer.perform_async(id: random_uuid)
  "Sent job #{i} with id #{random_uuid} to the queue."
end
