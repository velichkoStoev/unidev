require 'rails_helper'

describe SkillsController do
  let!(:current_user) { FactoryGirl.create(:user) }

  before { sign_in current_user }

  describe 'POST create' do
    let(:params) { { user_id: current_user.id, skill: { name: 'Test' } } }

    context 'when there isn\'t a skill with the provided name' do
      before { xhr :post, :create, params, format: :js }

      it 'creates the Skill record' do
        skill = Skill.first

        expect(skill.name).to eq('Test')
      end

      it { expect(response).to render_template(:create) }
      it { expect(response).to have_http_status(:ok) }
    end

    context 'when the user does not have this skill' do
      before { xhr :post, :create, params, format: :js }

      it { expect(current_user.skills.first.name).to eq('Test') }
      it { expect(response).to render_template(:create) }
      it { expect(response).to have_http_status(:ok) }
    end

    context 'when the user already has this skill' do
      let!(:skill) { FactoryGirl.create(:skill, name: 'Test') }
      let!(:user_skill) { FactoryGirl.create(:user_skill, user: current_user, skill: skill) }

      before { xhr :post, :create, params, format: :js }

      it { expect(response).to render_template(:new) }
      it { expect(response).to have_http_status(:ok) }
    end

    context 'when the params are invalid' do
      before do
        params[:skill][:name] = ''
        xhr :post, :create, params, format: :js
      end

      it { expect(response).to render_template(:new) }
      it { expect(response).to have_http_status(:ok) }
    end
  end

  describe 'DELETE destroy' do
    let!(:skill_to_delete) { FactoryGirl.create(:skill, name: 'Skill to delete') }
    let!(:another_skill) { FactoryGirl.create(:skill, name: 'Another skill') }

    let!(:user_skill_1) { FactoryGirl.create(:user_skill, user: current_user, skill: skill_to_delete) }
    let!(:user_skill_2) { FactoryGirl.create(:user_skill, user: current_user, skill: another_skill) }

    let(:params) { { user_id: current_user.id, id: skill_to_delete.id } }

    before { xhr :delete, :destroy, params, format: :js }

    it { expect(current_user.skills.count).to eq(1) }
    it { expect(current_user.skills.first.name).to eq(another_skill.name) }
    it { expect(response).to render_template(:destroy) }
    it { expect(response).to have_http_status(:ok) }
  end

  describe 'GET name_suggestions' do
    let(:params) { { term: 'Nam' } }
    let!(:skill_1) { FactoryGirl.create(:skill, name: 'Name 1') }
    let!(:skill_2) { FactoryGirl.create(:skill, name: 'Name 2') }
    let!(:skill_3) { FactoryGirl.create(:skill, name: 'Skill') }

    before { get :name_suggestions, params }

    it { expect(response).to have_http_status(:ok) }
    it { expect(response.body).to eq([skill_1.name, skill_2.name].to_json) }
  end
end
