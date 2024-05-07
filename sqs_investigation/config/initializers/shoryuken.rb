Rails.application.config.to_prepare do
  sqs_client_options = {
    region: "us-west-1",
    retry_mode: "standard",
    max_attempts: 2,
    http_open_timeout: 2,
    http_read_timeout: 3,
    log_level: :debug
  }

  Shoryuken.configure_server do |config|
    config.server_middleware do |chain|
      chain.remove Shoryuken::Middleware::Server::Timing
    end

    config.sqs_client_receive_message_opts = {wait_time_seconds: 20}

    Aws::SQS::Client.remove_plugin(Aws::Plugins::UserAgent)

    config.sqs_client = Aws::SQS::Client.new(sqs_client_options.merge(http_read_timeout: 21))
  end

  Shoryuken.configure_client do |config|
    config.sqs_client = Aws::SQS::Client.new(sqs_client_options)
  end

  Shoryuken.launcher_executor = Concurrent::CachedThreadPool.new(auto_terminate: true, name: "shoryuken")
end
