require 'pry'
require './capybara_conf.rb'

require 'mongo'
require 'open-uri'
require 'nokogiri'

# q = client[:q_links].find({:processed => true}).to_a

# (a.each do |z|
#   z['processed'] = false
#   client[:q_links].update_one({:_id => z['_id']}, '$set' => z)
# end)

Mongo::Logger.logger.level = ::Logger::FATAL
client = Mongo::Client.new([ ''], database: '', user: '', password: '')

question_links = client[:q_links].find({:processed => false}).to_a

question_links.each do |q_link|
  url = q_link['href']
  id = q_link['_id']

  puts url
  page = nil
  begin
    page = Nokogiri::HTML(open(url)) 
  rescue Exception => e
   print e
   next
  end
  answer = page.css 'div.contentQuestion'
  text = answer[0].text.strip

  persist = {:text => text, :q_reference => id }
  client[:answer].insert_one persist

  questions = page.css 'a.question'

  persist = []
  questions.each do |question|
    if not question.nil?
        persist << {:title => question.text.strip, :q_link_reference => id }
    end
  end
  puts persist
  puts "Quantidade " << persist.length.to_i
  
  client[:client_q_related].insert_many persist

  q_link['processed'] = true
  client[:q_links].update_one({:_id => id }, q_link)
  sleep(5)
end