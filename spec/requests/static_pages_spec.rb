require 'rails_helper'

describe "static pages", type: :request do

  subject {page}

  shared_examples_for "all static pages" do
     it {should have_content(heading)}
  end


  describe "Home page" do
    before{ visit movies_path}
    let(:heading) {'All Movies'}
    it_should_behave_like "all static pages"
  end

  describe "New Page" do
      before {visit new_movie_path}
      let(:heading) {'Create New Movie'}
      it_should_behave_like "all static pages"
  end

  let(:movie) {FactoryGirl.create(:movie)}
  describe "Info page" do
     let(:heading) {"Details about #{movie.title}"}
     before do 
        visit movie_path(movie)
     end
     it_should_behave_like "all static pages"

  end

  describe "edit page" do
     let(:heading) {"Edit Existing Movie"}
     before do 
        visit edit_movie_path(movie)
     end
     it_should_behave_like "all static pages"

  end
end
