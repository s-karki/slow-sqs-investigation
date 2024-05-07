desc "Publish some message to SQS"
namespace :sqs_investigation do
  task publish: :environment do
    # Rake.application.rake_require "#{Rails.root}/app/jobs/investigation_job.rb"

    num_jobs = 100
    num_jobs.times do |i|
      random_uuid = SecureRandom.uuid
      InvestigationJob.perform_later(random_uuid)
      puts "enqueued job #{random_uuid}"
    end
  end
end
