require 'rails_helper'

describe MessagesController do
  let!(:current_user) { FactoryGirl.create(:user) }

  before { sign_in current_user }

  describe 'GET index' do
    before { get :index, user_id: current_user.id }

    it { expect(response).to render_template(:index) }
    it { expect(response).to have_http_status(:ok) }
  end
end
