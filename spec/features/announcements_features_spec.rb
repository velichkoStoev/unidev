require 'rails_helper'

describe 'Announcements Features' do
  let(:text_1) { 'testtesttesttesttest1' }
  let(:text_2) { 'testtesttesttesttest2' }

  feature 'User checks the announcements' do
    let!(:current_user) { FactoryGirl.create(:user) }
    let!(:announcement_1) { FactoryGirl.create(:announcement, user: current_user, text: text_1) }
    let!(:announcement_2) { FactoryGirl.create(:announcement, user: current_user, text: text_2) }

    before do
      login_as(current_user, scope: :user)
      visit '/announcements'
    end

    scenario 'they see a table with announcements' do
      expect(page).to have_selector('h3', text: 'Announcements', count: 1)
      expect(page).to have_selector('table', count: 1)
      expect(page).to have_selector('td', text: text_1)
      expect(page).to have_selector('td', text: text_2)
      expect(page).to have_selector('td', text: current_user.full_name)
    end
  end

  feature 'User clicks on announcement' do
    let!(:current_user) { FactoryGirl.create(:user) }

    before { login_as(current_user, scope: :user) }

    shared_examples_for 'showing the announcement\'s page' do
      it { expect(page).to have_selector('h1', text: text_1) }
      it { expect(page).to have_selector('p', text: announcement.project.name) }
    end

    context 'when the logged user is the creator of the announcement' do
      let!(:announcement) { FactoryGirl.create(:announcement, user: current_user, text: text_1) }

      before do
        visit '/announcements'
        first('td a').click
      end

      it_behaves_like 'showing the announcement\'s page'
      it { expect(page).to have_selector('p', text: "By #{current_user.full_name}") }
      it { expect(page).not_to have_selector('btn') }
    end

    context 'when the announcement is created by another user' do
      let!(:user_with_announcement) { FactoryGirl.create(:user) }
      let!(:announcement) { FactoryGirl.create(:announcement, user: user_with_announcement, text: text_1) }

      before do
        visit '/announcements'
        first('td a').click
      end

      it_behaves_like 'showing the announcement\'s page'
      it { expect(page).to have_selector('p', text: "By #{user_with_announcement.full_name}") }
      it { expect(page).to have_selector('a.btn', text: 'Send participation request') }
    end
  end
end
