# Mini Test

require 'minitest/spec'
require 'minitest/autorun'
require_relative '../scrape'

describe Scrape do
  it "should scrape colleges name, rank, etc., details as json formated" do
    scrape = Scrape.new
    college_details = scrape.start_scraping_web_page(1)
    college_details.first["name"].must_equal "Princeton University"
    college_details.first["rank"].must_equal 1
    college_details.first["acceptance_rate"].must_equal "7.4%"
    college_details.first["graduation_rate"].must_equal "90%"
    college_details.first["average_retention_rate"].must_equal "98%"
    college_details.first["tuition_fees"].must_equal "$43,450"
    college_details.first["total_enrollment"].must_equal "5,391"
  end
end
