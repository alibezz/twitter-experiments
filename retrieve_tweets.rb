require "rubygems"
require "twitter"

sustainability_tweets = []
keywords = ["#cleantech", "#climatechange", "#cop17", "eco", "ecofriendly",
            "ecology", "EcoMonday", "#econews", "#energy", "environment",
            "#green", "#greenbiz", "greenpeace", "#greenbuilding",
            "#greenbusiness", "#greenliving", "recycling", "#renewableenergy", 
            "sustainability", "#sustainable", "#waterwednesday"]

def retrieve_keyword(keyword, tweets) 
  puts "Keyword #{keyword}"
  search = Twitter::Search.new
  for i in 1..100
    s =  search.containing(keyword).page(i).fetch
    break if s.empty?
    tweets += s
    puts s.first.text
    search.clear  
    #    sleep 10 unless i % 10
  end
  tweets
end 

def backup_tweets(keyword, tweets)
  file = File.open("#{keyword}_file.txt", "a+")
  tweets.each do |t|
    file.write("#{t.from_user}\n#{t.created_at}\n#{t.text}\n\n")
  end
  file.close
end 

keywords.each do |k|
  backup_tweets(k, retrieve_keyword(k, sustainability_tweets))
end
