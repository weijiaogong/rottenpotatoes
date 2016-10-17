require 'rails_helper'

describe "home page", type: :request do

  subject {page}

  shared_examples_for "all static pages" do
     it {should have_content(heading)}
  end


  describe "Home page" do

    before {visit movies_path}
    let(:heading) {'All Movies'}
    it_should_behave_like "all static pages"
  end

 describe "New Page" do
    
      before {visit new_movie_path}
      let(:heading) {'Create New Movie'}
      it_should_behave_like "all static pages"
  end


  describe "Links" do
     before do
        let(:movie) {FactoryGirl.create(:movie)}
     end
 
    it "should have the right links on the layout" do
	visit movies_path

        click_link "Add new movie"
	expect(page).to have_content('Create New Movie')
	click_link "More about #{movie.title}"
	expect(page).to have_content('Details about')
    end

    it "should have highlight the selected column tilte" do
	visit movies_path
	click_link "Movie Title"
	expect(page).to have_css('th.hilite')
    end

    it "should have highlight the selected column tilte" do
	visit movies_path
	click_link "Release Date"
	expect(page).to have_css('th.hilite')
    end

  end


  describe "checkbox" do
     page.check('rating['G'])


  end
end
