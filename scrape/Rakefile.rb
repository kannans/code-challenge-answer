require_relative "scrape"

desc 'Scrape universities details!!!'
task :scrape do
  data = Scrape.new
  puts "Scrape is running please wait...."
  data.run
  puts "Scrape completed. Please view the universities.html in firefox/safari/chrome browser."
end
