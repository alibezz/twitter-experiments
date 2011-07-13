require "rubygems"
require "twitter"
require "logger"

sustainability_tweets = []
keywords = ["#cleantech", "#climatechange", "#cop17", "eco", "ecofriendly",
            "ecology", "EcoMonday", "#econews", "#energy", "environment",
            "#green", "#greenbiz", "greenpeace", "#greenbuilding",
            "#greenbusiness", "#greenliving", "recycling", "#renewableenergy", 
            "sustainability", "#sustainable", "#waterwednesday"]

def retrieve_keyword(keyword, tweets) 
  puts "Keyword #{keyword}"
  log = Logger.new("#{keyword}_log.txt")
  search = Twitter::Search.new

  for i in 1..100
    begin
      s =  search.containing(keyword).since("2011-07-08").page(i).fetch
      break if s.empty?
      tweets += s
      puts s.first.text
      search.clear
    rescue Errno::ENOENT, Errno::ETIMEDOUT, Errno::ECONNRESET
      sleep(5)
      log.info "Connection error - attempting to retry"
      retry
    rescue
      log.info "Something unexpected happened and page #{i} wasn't retrieved"
    end
  end

  tweets
end 

def backup_tweets(keyword, tweets)
  file = File.open("#{keyword}_file.txt", "a+")
  
  tweets.each do |t|
    #FIXME t.whatever must fill a single line
    file.write("#{t.from_user}\n#{t.created_at}\n#{t.text}\n\n")
  end
  
  file.close
end 

keywords.each do |k|
  backup_tweets(k, retrieve_keyword(k, sustainability_tweets))
end
