require 'rails_helper'

describe UsersController do
  feature 'Listing the registered users' do
    let!(:user) { FactoryGirl.create(:user) }

    before { visit users_path }

    scenario 'a table with information about the users is displayed' do
      expect(page).to have_selector('.panel-heading h3', text: 'Users')
      expect(page).to have_link(user.full_name)
      expect(page).to have_selector('td', text: user.email)
      expect(page).to have_selector('td', text: user.faculty)
      expect(page).to have_selector('td', text: user.about_me)
    end
  end

  feature 'Visiting a user profile page' do
    let(:truncated_announcement_text) { "#{announcement.text.first(21)}..." }

    let!(:current_user) { FactoryGirl.create(:user) }
    let!(:user) { FactoryGirl.create(:user) }
    let!(:skill) { FactoryGirl.create(:skill) }
    let!(:user_skill) { FactoryGirl.create(:user_skill, skill: skill, user: user) }
    let!(:project) { FactoryGirl.create(:project, creator: user) }
    let!(:project_participation) { FactoryGirl.create(:project_participation, project: project, user: user) }
    let!(:announcement) { FactoryGirl.create(:announcement, user: user, project: project) }

    before do
      login_as(current_user, scope: :user)
      visit user_path(user.id)
    end

    scenario 'displays user\'s avatar' do
      expect(page).to have_selector('img.img-rounded.img-responsive')
    end

    scenario 'shows a brief information about the user' do
      expect(page).to have_selector('.panel-heading', text: 'Information')
    end

    scenario 'shows an about me block' do
      expect(page).to have_selector('.panel-heading', text: "About #{user.first_name}")
      expect(page).to have_selector('.panel-body', text: user.about_me)
    end

    scenario 'lists user\'s skills' do
      expect(page).to have_selector('.panel-heading', text: 'Skills')
      expect(page).to have_selector('li.list-group-item', text: skill.name)
    end

    scenario 'lists user\'s announcements' do
      expect(page).to have_selector('.panel-heading', text: 'Announcements')

      within('.col-md-8 .panel.panel-info') do
        expect(page).to have_link(truncated_announcement_text)
        expect(page).to have_link(announcement.project.name)
      end
    end

    scenario 'lists user\'s projects' do
      expect(page).to have_selector('.panel-heading', text: 'Projects')
      expect(page).to have_link(project.name)
      expect(page).to have_selector('td', text: project.information)
      expect(page).to have_selector('td', text: project.date_created)
      expect(page).to have_selector('td', text: project.date_updated)
      expect(page).to have_selector('td', text: 'Yes')
    end
  end

  feature 'Searching for a user by an email' do
    before { visit users_path }

    context 'when there aren\'t any registered users' do
      before do
        within 'form.simple_form.form-inline' do
          fill_in('search_user_email', with: 'testmail')
          click_button('Go!')
        end
      end

      scenario { expect(page).to have_selector('h3', text: '0 results found.') }
    end

    context 'when there aren registered users' do
      let!(:user_1) { FactoryGirl.create(:user, email: 'testuseremail@unidev.com') }
      let!(:user_2) { FactoryGirl.create(:user, email: 'anothertestusermail@unidev.com') }

      context 'but there aren\'t any user emails matching the provided search input' do
        before do
          within 'form.simple_form.form-inline' do
            fill_in('search_user_email', with: 'testmail')
            click_button('Go!')
          end
        end

        scenario { expect(page).to have_selector('h3', text: '0 results found.') }
      end

      context 'and there are user email matching the provided search input' do
        before do
          within 'form.simple_form.form-inline' do
            fill_in('search_user_email', with: 'testuseremail')
            click_button('Go!')
          end
        end

        scenario 'displays a table with the results' do
          expect(page).to have_link(user_1.full_name)
          expect(page).to have_selector('td', text: user_1.email)
          expect(page).to have_selector('td', text: user_1.faculty)
          expect(page).to have_selector('td', text: user_1.about_me)
        end

        scenario { expect(page).to have_selector('h3', text: '1 result found.') }
      end
    end
  end
end
