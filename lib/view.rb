class View
  def display(recipes) # expects array of recipes
    recipes.each_with_index do |recipe, index|
      rating = recipe.rating.nil? ? 'Not rated yet' : "#{recipe.rating} / 5"
      puts "[#{recipe.done? ? "X" : " "}] #{index + 1}. #{recipe.name} | #{rating}"
      puts "Rating: #{rating} | Prep time: #{recipe.prep_time}"
      puts "    #{recipe.description[0..20]}...\n\n"
    end
  end

  def ask_for(something)
    puts "Give me a #{something} 💁"
    print '> '
    gets.chomp
  end
end
