require 'open-uri'
require 'nokogiri'


class ScrapeService
  def initialize(keyword)
    @keyword = keyword
  end

  def call
    url = "https://www.foodnetwork.com/search/#{@keyword}-"
    html_doc = URI.open(url).read
    parsed_html = Nokogiri::HTML(html_doc)

    recipe_infos = []

    # Recipes page
    # scrape each recipes
    # for each of them
    parsed_html.search('.o-RecipeResult.o-ResultCard').first(5).each do |recipe_card|
      # get the name
      name = recipe_card.search('.m-MediaBlock__a-HeadlineText').text.strip
      # get the prep_time
      prep_time = recipe_card.search('.o-RecipeInfo__a-Description.a-Description').text.strip
      # get the rating
      rating = recipe_card.search('.gig-rating-stars').attribute('title').value.split(" ")[0]
      # get the details page url
      details_url = "https:" + recipe_card.search('.m-MediaBlock__m-Rating a').attribute('href').value
      # scrape the details page
      details_html_doc = URI.open(details_url).read
      details_parsed_html = Nokogiri::HTML(details_html_doc)
      # get the description
      description = details_parsed_html.search('.o-Method__m-Body').text.gsub("\n", " ").squeeze(" ").strip

      recipe_infos << {name: name, prep_time: prep_time, rating: rating, url: details_url, description: description}
    end

    recipe_infos
  end
end