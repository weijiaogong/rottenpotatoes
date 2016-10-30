require 'rails_helper'

describe "index page" do
  subject {page}
  describe "Links" do
    before do
      visit movies_path
    end
 
    it "should have the add new movie link on the layout" do	
      click_link "Add new movie"
	    expect(page).to have_content('Create New Movie')
    end

    it "should have the details link for each movie" do
      @movie = FactoryGirl.create(:movie)
      visit movies_path
    	click_link "More about #{@movie.title}"
    	expect(page).to have_content('Details about')
    end
    it "should not highlighted unselected column tilte" do
      expect(page).to have_css('th.hilite',count: 0)
    end
    it "should have highlight the selected column tilte" do
    	click_link "Movie Title"
    	expect(page).to have_css('th.hilite', count: 1)
    end

    it "should have highlight the selected column Release Date" do
    	click_link "Release Date"
    	expect(page).to have_css('th.hilite', count: 1)
    end

  end

 
  describe "checkbox" do
      before {visit movies_path}
      let(:all_ratings){Movie.all_ratings}
      it "should respond to user's setting" do
         all_ratings.each do |rating|
      		 page.check("ratings[#{rating}]")
      		 click_button "Refresh"
           expect(page).to have_content("All Movies")
           page.uncheck("ratings[#{rating}]")
         end
      end
  end

end
