require 'shoryuken'

class ShoryukenConsumer
  include Shoryuken::Worker

  shoryuken_options queue: 'sqs-investigation', auto_delete: true

  def perform(sqs_msg, id)
    puts "processing job #{id}}"
  end
end
