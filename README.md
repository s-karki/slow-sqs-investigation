
Run `ruby shoryuken_producer.rb` to run publish jobs to the `sqs-investigation` queue

Run `bundle exec shoryuken -q sqs-investigation -r ./shoryuken_consumer.rb` to dequeue jobs
