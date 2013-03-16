class MessagesController < ApplicationController
  include ActionController::Live
  @@lock = Mutex.new

  def index
    @@lock.synchronize do
      @messages = Message.all
    end
  end

  def create
    @@lock.synchronize do
      attributes = params.require(:message).permit(:content, :name)
      @message = Message.create(attributes)
      $redis.publish('messages.create', @message.to_json)
      head :created, location: @message
    end
  end
  
  def events
    logger.info 'Stream connected'
    response.headers['Content-Type'] = 'text/event-stream'
    redis = Redis.new(REDIS_OPTIONS)
    redis.psubscribe('messages.*') do |on|
      on.pmessage do |pattern, event, data|
        response.stream.write("event: #{event}\n")
        response.stream.write("data: #{data}\n\n")
      end
    end
  rescue IOError
    logger.info 'Stream closed'
  ensure
    redis.quit if redis
    response.stream.close
  end
end
