require 'pry'
require './capybara_conf.rb'

require 'mongo'
Mongo::Logger.logger.level = ::Logger::FATAL
client = Mongo::Client.new([ ''], database: '', user: '', password: '')

browser = Capybara.current_session

urls = []

(1..20).each do |index| 
  urls << "http://faq.netcombo.com.br/faq-2/perguntas-frequentes/page/#{index}/"
end

urls.each do |url| 
  browser.visit url
  questions = browser.all 'a.question'
  
  questions.each do |question|
    persist = {:title => question.text, :href => question['href'], :processed => false }
    puts persist
    client[:q_links].insert_one persist
  end
  sleep(30)
end
