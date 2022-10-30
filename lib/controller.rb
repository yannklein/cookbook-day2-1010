require_relative 'view'
require_relative 'recipe'
require_relative 'scrape_service'

class Controller
  def initialize(cookbook) # expected to be an instance of Cookbook
    @cookbook = cookbook
    @view = View.new
  end

  def list # TODO: display all the recipes in the cookbook
    # 1. get the recipes from cookbook (cookbook)
    recipes = @cookbook.all
    # 2. display them in terminal (view)
    @view.display(recipes)
  end

  def create
    # 1. ask for the name
    name = @view.ask_for(:name)
    # 2. ask for description
    description = @view.ask_for(:description)
    # 3. ask for prep_time
    prep_time = @view.ask_for(:prep_time)
    recipe = Recipe.new(name, description, prep_time)
    # 5. save the new recipe to the cookbook
    @cookbook.add_recipe(recipe)
  end

  def destroy
    # 1. display the recipes
    list
    # 2. ask for index
    index = @view.ask_for(:number).to_i - 1
    # 3. remove the chosen recipe from the cookbook
    @cookbook.remove_recipe(index)
  end

  def import
    # ask the view to get keyword (string) from user
    keyword = @view.ask_for(:keyword)
    # scrape 5 recipes (array of instances of Recipe) from keyword
    scrape_service = ScrapeService.new(keyword)
    recipe_infos = scrape_service.call
    # create array of recipe instances
    recipes = recipe_infos.map do |recipe_info| 
      Recipe.new(
        recipe_info[:name], 
        recipe_info[:description], 
        recipe_info[:prep_time],
        recipe_info[:rating]
      ) 
    end
    # ask the view to display recipes, ask user for an index
    @view.display(recipes)
    index = @view.ask_for(:index).to_i - 1
    # get recipe based on index
    recipe = recipes[index]
    # ask cookbook to store the recipe (add_recipe)
    @cookbook.add_recipe(recipe)
    # list recipes
    list
  end

  def mark_as_done
    # 1. display the recipes
    list
    # 2. ask for index
    index = @view.ask_for(:number).to_i - 1
    # 3. ask cookbook to mark the chosen recipe as done
    @cookbook.recipe_done!(index)
    # 4. list recipes
    list
  end
end
