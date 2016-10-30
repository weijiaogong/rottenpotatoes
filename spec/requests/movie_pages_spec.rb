require 'rails_helper'

RSpec.describe "MoviePages" do
  subject {page}

  describe "Details Page" do
    let(:movie) {FactoryGirl.create(:movie)}
    before {visit movie_path(movie)}
    it {should have_content(movie.title)}

    it "should have the right links on the layout" do
	    visit movie_path(movie)
      click_link "Edit"
      expect(page).to have_content('Edit Existing Movie')

      visit movie_path(movie)
      click_link "Back to movie list"
	    expect(page).to have_content('All Movies')

      visit movie_path(movie)
      click_link "Find Movies With Same Director"
      expect(page).to have_content('Similar Movies')

	    visit movie_path(movie)
      click_button "Delete"
	    expect(page).to have_content('All Movies')
    end
  end

  describe  "New Movie Page" do
    before {visit new_movie_path}
	  let(:submit) {"Save Changes"}
    let(:movie) {FactoryGirl.create(:movie)}
  
    describe "Create a valid movie" do
  		before do
  		   fill_in "Title",  with: "Example Movie"
         fill_in "Director", with: "Example Director"
         click_button submit 
  		end

  	  describe "after saved changes" do
  		    it "should create a new movie" do               
  		      expect(page).to have_content ('was successfully created.')
  		    end
      end
    end
    describe "Create a invalid movie" do
      before {click_button submit}
      it {should have_content ('Validation failed')}
    end   
	end

  describe  "Update Movie Page" do
    let(:movie) {FactoryGirl.create(:movie)}
    let(:submit) {"Update Movie Info"}
    before do
      visit movie_path(movie)
      click_link "Edit"
    end
    
  
    describe "Valid Updation" do
      before do
         fill_in "Title",  with: "Update Movie"
         fill_in "Director", with: "Update Director"
         click_button submit 
      end
      describe "after saved changes" do
          it "updated the movie infomation" do               
            expect(page).to have_content ('was successfully updated')
          end
      end
    end
    describe "invalid Updation" do
      before do
        fill_in "Title",  with: ""
        click_button submit
      end
      it {should have_content ('Validation failed')}
    end  
  end
  
end
