class InvestigationJob < ApplicationJob
  queue_as 'sqs-investigation'

  def perform(id)
    puts "processing job #{id}"
  end
end
