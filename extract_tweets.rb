TWEET_SIZE = 3

def read_file(dir, keyword)
  filename = File.join(dir, "#{keyword}_file.txt")
  file = File.open(filename, "r+")
  lines = file.readlines
  file.close
  lines.delete_if { |l| l == "\n" }
end 

def remove_repeated_tweets(tweets)
  lim = tweets.size - 1
  key = ""
  unique = {}
  
  for i in 0..lim do
    if i % TWEET_SIZE == 0
      key = tweets[i]     
    elsif i % TWEET_SIZE == 1
      p key
      p i
      key << tweets[i]
      unique.merge!({key => tweets[i + 1]}) unless unique.has_key?(key)
    else
      next
    end
  end
  unique
end

def write_tweet_texts(keyword, tweets)
  file = File.open("#{keyword}_texts.txt", "w+")
  
  tweets.each do |key, text|
    file.write(text)
  end
  
  file.close
end

origin_dir = ARGV.shift
keyword = ARGV.shift
lines = read_file(origin_dir, keyword)

#unique refers to unique keys - i.e., unique name + timestamp
# retweeted texts are allowed. It's important to leave them
# since they help measuring the importance of a term
unique = remove_repeated_tweets(lines)
write_tweet_texts(keyword, unique) 

