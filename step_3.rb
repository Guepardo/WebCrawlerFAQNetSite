require 'mongo'
require 'json'
require 'pry'

Mongo::Logger.logger.level = ::Logger::FATAL
client = Mongo::Client.new([ ''], database: '', user: '', password: '')

question_links = client[:q_links].find.to_a
question_links.each do |q_link|
  training_set = []

  id = q_link['_id']
  answer = client[:answer].find({:q_reference => q_link['_id']}).to_a[0]
  
  next if answer.nil?

  file = File.open("output/#{id}.js", 'w')

  q_related = client[:client_q_related].find({:q_link_reference => id}).to_a

  training_set << {:question => q_link['title'], :answer => answer['text']}
  
  q_related.each do |related|
    puts related
    training_set << {:question => related['title'], :answer => answer['text']}
  end

  file.write(training_set.to_json.to_s)
  file.close
end