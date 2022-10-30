require 'csv'
require_relative 'recipe'

class Cookbook
  def initialize(csv_file)
    @recipes = []
    @csv_file = csv_file
    load
  end

  def all # TODO: return all the recipes in the cookbook
    @recipes
  end

  def add_recipe(recipe) # expects an instance of Recipe
    @recipes << recipe
    save
  end

  def remove_recipe(recipe_index) # expects an Integer
    @recipes.delete_at(recipe_index)
    save
  end

  def recipe_done!(recipe_index)
    recipe = @recipes[recipe_index]
    recipe.done = true
    save
  end

  private

  def load
    CSV.foreach(@csv_file) do |row|
      @recipes << Recipe.new(row[0], row[1], row[2], row[3], row[4] == true)
    end
  end

  def save
    CSV.open(@csv_file, 'wb') do |csv|
      @recipes.each do |recipe|
        csv << [recipe.name, recipe.description, recipe.prep_time, recipe.rating, recipe.done?]
      end
    end
  end
end
