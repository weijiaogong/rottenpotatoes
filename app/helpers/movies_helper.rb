module MoviesHelper
	# check if the column 'sortby' is what user selected, if true, highlight the column title
  def if_sortby(sortby)
      if @sortby == sortby
         :hilite
      end
  end
end
