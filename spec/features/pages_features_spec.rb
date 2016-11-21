require 'rails_helper'

describe 'Pages Features' do
  let!(:current_user) { FactoryGirl.create(:user) }

  feature 'Visiting the home page' do
    shared_examples_for 'displaying the static content' do
      it 'presents all the necessary information' do
        expect(page).to have_selector('a.navbar-brand', text: 'UniDev')
        expect(page).to have_selector('h1', text: 'Welcome to UniDev')
        expect(page).to have_selector('p', text: 'Place for ideas, development and teamwork')
        expect(page).to have_selector('.h2', text: 'What?')
        expect(page).to have_selector('.h2', text: 'Why?')
        expect(page).to have_selector('.h2', text: 'How?')
      end
    end

    context 'when there is a logged in user' do
      before do
        login_as(current_user, scope: :user)
        visit root_path
      end

      it_behaves_like 'displaying the static content'

      scenario 'they see the dashboard and the dropdown profile options' do
        expect(page).to have_selector('li a', text: 'Dashboard')
        expect(page).to have_selector('li a', text: 'Profile')
        expect(page).to have_selector('li a', text: 'View Profile')
        expect(page).to have_selector('li a', text: 'Control Panel')
        expect(page).to have_selector('li a', text: 'Log Out')
      end
    end

    context 'when there isn\'t a logged in user' do
      before { visit root_path }

      it_behaves_like 'displaying the static content'

      it 'they see the the register and login options' do
        expect(page).to have_selector('li a', text: 'Log In')
        expect(page).to have_selector('li a', text: 'Register')
      end
    end
  end

  feature 'User visits the dashboard page' do
    let!(:project) { FactoryGirl.create(:project) }
    let!(:project_participation) { FactoryGirl.create(:project_participation, user: current_user, project: project) }
    let!(:announcement) { FactoryGirl.create(:announcement, user: current_user, project: project) }

    feature 'Displaying dashboard data' do
      let(:truncated_announcement_text) { "#{announcement.text.first(21)}..." }

      before do
        login_as(current_user, scope: :user)
        visit dashboard_path
      end

      it { expect(page).to have_selector('.row h1', text: "Welcome, #{current_user.first_name}") }

      scenario 'they see a table with information about their projects' do
        expect(page).to have_selector('.panel-heading h3', text: 'Projects')
        expect(page).to have_selector('.table.table-bordered td', text: project.name)
        expect(page).to have_selector('.table.table-bordered td', text: project.information)
        expect(page).to have_selector('.table.table-bordered td', text: project.date_created)
        expect(page).to have_selector('.table.table-bordered td', text: project.date_updated)
        expect(page).to have_selector('.table.table-bordered td', text: project.repository_url)
      end

      scenario 'they see a table with information about their announcements' do
        expect(page).to have_selector('.panel-heading h3', text: 'Announcements')
        expect(page).to have_content(truncated_announcement_text)
      end
    end

    feature 'Messages notifications' do
      before { login_as(current_user, scope: :user) }

      context 'when there are new messages' do
        let!(:received_message) { FactoryGirl.create(:message, receiver: current_user) }

        before { visit dashboard_path }

        scenario 'they see a warning block' do
          expect(page).to have_selector('.alert.alert-warning')
          expect(page).to have_selector('.alert.alert-warning .p', text: 'You have 1 unread message')
          expect(page).to have_link('View inbox')
        end
      end

      context 'when there are no new messages' do
        before { visit dashboard_path }

        scenario { expect(page).not_to have_selector('.alert.alert-warning') }
      end
    end
  end
end
