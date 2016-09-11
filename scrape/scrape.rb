# Problem 3 - Scrape web page.

require 'mechanize'
require 'json'
require 'ruby-progressbar'

class Scrape
  BASE_URL = "http://colleges.usnews.rankingsandreviews.com/best-colleges/rankings/national-universities/data".freeze
  TOTAL_PAGES = 12.freeze
  JSON_FILE = "data.json".freeze

  def run
    all_data = []
    progressbar = ProgressBar.create # progress bar

    (0..TOTAL_PAGES).to_a.each do |page|
      progressbar.increment
      all_data << start_scraping_web_page(page)
    end
    progressbar.finish
    create_json_file(all_data.flatten)
  end

  def start_scraping_web_page(page_number)
    scrap_college = []
    page = get_page_content(page_number)
    page_content = page.search(".//table[@class='flex-table']")
    page_content.css("tr").each do |data|
      college = {}

      # Name and Rank
      if data.css("td").first
        college["name"] = normalize_text(data.css("td")[0].css(".block-tighter a").text)
        college["rank"] = find_rank(data.css("td")[0].css(".text-strong").last)

        college["acceptance_rate"], college["graduation_rate"], college["average_retention_rate"] =
          get_acceptance_rate(page, college["name"])
      end

      # Tuition_fees
      if data.css("td")[1]
        college["tuition_fees"] = normalize_text(data.css("td")[1].text)
      end

      # Entrollment
      if data.css("td")[2]
        college["total_enrollment"] = normalize_text(data.css("td")[2].text)
      end

      if valid_json?(college)
        scrap_college << college

        # Create a data.json file
        create_json_file(scrap_college)
      end
    end
    scrap_college
  end

  def get_page_content(page_number)
    page = "?_page=#{page_number}" if page_number != 0
    url = "#{base_url}#{page}"
    mechanize.get(url)
  end

  def get_acceptance_rate(page, univ_name)
    # Click and navigate to University details page.
    link = page.link_with(text: univ_name)
    univ_page = link.click

    # Acceptance Rate
    page_content = univ_page.css(".block-normal .data-dictionary-field .text-strong")[1]
    acceptance_rate = normalize_text(page_content.text) unless page_content.nil?

    # Graduation Rate
    page_content = univ_page.css(".block-normal .data-dictionary-field .text-strong")[5]
    graduation_rate = normalize_text(page_content.text) unless page_content.nil?

    # Find average_retention_rate
    average_retention_rate = get_average_retention_rate(univ_page)

    return [acceptance_rate, graduation_rate, average_retention_rate]
  end

  def get_average_retention_rate(univ_page)
    # Navigate to academics page
    url = "#{univ_page.uri}/academics"
    academics_page = mechanize.get(url)

    # Average Retention Rate
    page_content = academics_page.css("#GraduationAndRetention .data-dictionary-field .text-strong")
    normalize_text(page_content.text)
  rescue
    "404 page not found"
  end

  private

  def mechanize
    @_mechanize ||= Mechanize.new
  end

  def base_url
    @_base_url ||= BASE_URL
  end

  def normalize_text(text)
    text.tr("\n", "").strip
  end

  def find_rank(rank_text)
    unless rank_text.nil?
      rank = rank_text.text.scan(/\d+/).join().to_i
      if rank.zero?
        rank = rank_text.text
      end
      rank
    end
  end

  def create_json_file(data)
    preety_json = JSON.pretty_generate(data)
    file = File.new(JSON_FILE, "w+")
    file.puts preety_json
    file.close
  end

  def valid_json?(college)
    college["name"] && college["name"] != ""
  end
end
