class Recipe
  attr_reader :name, :description, :rating, :prep_time
  attr_writer :done

  def initialize(name, description, prep_time, rating = nil, done = false)
    @name = name
    @description = description
    @done = done
    @rating = rating
    @prep_time = prep_time
  end

  def done?
    @done
  end
end
