require 'rails_helper'


describe MoviesController do


  describe 'index' do
    let(:movies){Movie.all}
    before {get :index}
    it "show all the movies in database" do
       expect(assigns(:movies)).to eq(movies)
    end
    it "renders the :index view" do
        expect(response).to render_template :index
    end

  end

  describe 'new' do
    before {get :new}
    it "renders the :new template" do
        expect(response).to render_template :new
    end
  
  end

  describe 'create' do

   context "with valid attributes" do
      
      before(:each) do
          movie_attributes = FactoryGirl.attributes_for(:movie)
          post :create, movie: movie_attributes
      end
      
      it "saves the new movie in the database" do
         movie = assigns(:movie)
         expect(movie).to be_kind_of ActiveRecord::Base
	 expect(movie).to be_persisted
         expect(Movie.all).to include movie
      end

      it "redirects to the home page" do
         expect(response).to redirect_to(movies_path)
      end
      after(:each) do
          Movie.destroy(assigns(:movie).id)
      end
    end
    

   context "with invalid attributes" do 
       before do
          movie_attributes = FactoryGirl.attributes_for(:movie, title: "")
          post :create, movie: movie_attributes
       end
       it "render new template" do
          expect(response).to render_template :new
       end
      
    end
  end

  
  describe 'show' do
    before do
      @movie = FactoryGirl.create(:movie)
      get :show, id: @movie.id
    end
    after do
      Movie.destroy(@movie.id)
    end
    it "assigns the requested movie to @movie" do
      expect(assigns(:movie)).to eq(@movie)
    end
    it "renders the :show template" do
        expect(response).to render_template :show
    end
  
  end
  
  describe 'edit' do

    before do
      @movie = FactoryGirl.create(:movie)
      get :edit, id: @movie.id
    end
    after do
      Movie.destroy(@movie.id)
    end

    it "renders the edit template" do
        expect(assigns(:movie)).to eq(@movie)
    end
    it "renders the edit template" do
        expect(response).to render_template :edit
    end
  end
  

  describe 'update' do
    context 'when valid' do
      let(:new_title) {"newtitle"}
      let(:new_values) { FactoryGirl.attributes_for(:movie, title: new_title)  }

    	before(:each) do
    	      @movie = FactoryGirl.create(:movie)
                  patch :update, id: @movie.id, movie: new_values
    	end
    	after(:each) do
    	      Movie.destroy(@movie.id)
    	end

    	it 'success' do
    	    expect(response).to redirect_to(movie_path(@movie))
    	end

    	it 'saves and assigns movie to @movie' do
    	    expect(assigns(:movie).title).to eq(new_title)
    	end

    	it 'saves updates' do
    	    expect { @movie.reload}.to change { @movie.title }.to(new_title)
    	end
    end

    context 'when invalid' do
      let(:new_values) { FactoryGirl.attributes_for(:movie, title: "") }
      before(:each) do
	      @movie = FactoryGirl.create(:movie)
        patch :update, id: @movie.id, movie: new_values
    	end
    	after(:each) do
    	      Movie.destroy(@movie.id)
    	end
      it 'fails' do
        expect(response).to redirect_to(edit_movie_path(@movie))
      end

      it 'assigns movie to @movie' do
        expect(@movie.reload).to eq @movie
      end
    end
  end

  describe 'destroy' do


    context 'when requested movie exists' do
      before(:each) do 
        @movie = FactoryGirl.create(:movie)
        delete :destroy, id: @movie.id
      end
      it 'success' do
        expect(response).to redirect_to(movies_path)
      end

      it 'removes movie form DB' do
        expect(Movie.all).not_to include @movie
        expect { @movie.reload }.to raise_exception ActiveRecord::RecordNotFound
      end
    end

    context 'when requested movie does not exists' do
      it 'throws ActiveRecord::RecordNotFound' do
        expect { delete :destroy, id: -1}.to raise_exception ActiveRecord::RecordNotFound
      end
    end
  end

end
