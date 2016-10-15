module MoviesHelper
  # Checks if a number is odd:
  def oddness(count)
    count.odd? ?  "odd" :  "even"
  end

  def if_sortby(sortby)
      if @column == sortby
         :hilite
      end
  end


  def get_ratings
      @all_ratings.select {|k,v| v ==  true}
  end

  def get_column
      @column
  end

  def get_setting
      ratings = get_ratings
      column  = get_column
      if !ratings.empty? || column
	      p = Hash.new
	      p[:ratings] = ratings
	      p[:column] =  column
      end
      return p
  end

end
