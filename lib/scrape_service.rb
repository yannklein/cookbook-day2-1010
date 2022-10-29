require 'open-uri'
require 'nokogiri'
require_relative 'recipe'

class ScrapeService
  def initialize(keyword)
    @keyword = keyword
  end

  def call
    url = "https://www.foodnetwork.com/search/#{@keyword}"
    html_doc = URI.open(url).read
    # 3. parse the html
    parsed_html = Nokogiri::HTML(html_doc)
    # 4. find first five recipes in the results
    results = parsed_html.search('.o-RecipeResult.o-ResultCard').first(5).map do |card|
      name = card.search('.m-MediaBlock__a-HeadlineText').text.strip
      description = card.search('.card__summary').text.strip
      prep_time = card.search('.o-RecipeInfo__a-Description.a-Description').text.strip
      rating = card.search('.gig-rating-stars').attribute('title').text.strip.split(' ')[0]

      # Look for 'a' tag that has the link to individual recipes
      recipe_url = card.search('.m-MediaBlock__m-Rating > a').first.attribute('href').value
      # Open the recipe page
      recipe_html =  URI.open("https:" + recipe_url)
      # Parse it
      parsed_recipe_html = Nokogiri::HTML(recipe_html)
      # Look for the element that has prep time information
      description = parsed_recipe_html.search('.o-Method__m-Body').text.strip.gsub("\n", ' ').squeeze(' ')
      
      Recipe.new(name, description, rating, prep_time)
    end

    return results
  end
end
