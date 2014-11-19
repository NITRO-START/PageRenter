require 'colorize'
require 'factory_girl'
Dir['/spec/factories/*'].each {|file| require file }

namespace :db do
  desc 'Populate PRODUCTION Database'
  task :prod => :environment do
    puts 'DB migration'.colorize(:yellow)
    system('rake db:migrate RAILS_ENV=production')
    puts 'DB population'.colorize(:green)
    system('rake db:seed RAILS_ENV=production')
  end
end