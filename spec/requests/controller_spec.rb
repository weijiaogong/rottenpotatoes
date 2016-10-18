require 'rails_helper'


describe "Controller", type: :controller do
   
  describe "GET #index" do
    it "populates an array of movies" do
       movie = FactoryGirl.create(:movie)
       get :index
       assigns(:movies).should eq([movie])
    end
    it "renders the :index view" do
        get :index
        response.should render_template :index
    end
  end
  
  describe "GET #show" do
    it "assigns the requested contact to @contact"
    it "renders the :show template"
  end
  
  describe "GET #new" do
    it "assigns a new Contact to @contact"
    it "renders the :new template"
  end
  
  describe "POST #create" do
    context "with valid attributes" do
      it "saves the new contact in the database"
      it "redirects to the home page"
    end
  end

end
