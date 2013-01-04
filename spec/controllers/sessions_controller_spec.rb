require 'spec_helper'

describe SessionsController do
  fixtures :all
  render_views

  let(:user) { User.first }

  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end

  it "create action should render new template when authentication is invalid" do
    User.stubs(:authenticate).returns(nil)
    post :create
    response.should render_template(:new)
    session['user_id'].should be_nil
  end

  it "create action should redirect when authentication is valid" do
    User.stubs(:authenticate).returns(user)
    post :create
    response.should redirect_to(user_path(user))
    session['user_id'].should == user.id
  end
end
