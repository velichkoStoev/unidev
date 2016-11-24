require 'rails_helper'

describe ProjectsController do
  feature 'Listing the existing projects' do
    let!(:project) { FactoryGirl.create(:project) }

    before { visit projects_path }

    scenario 'a table with information about the projects is displayed' do
      expect(page).to have_selector('.panel-heading h3', text: 'Projects')
      expect(page).to have_link(project.name)
      expect(page).to have_selector('td', text: project.information)
      expect(page).to have_selector('td', text: project.date_created)
      expect(page).to have_selector('td', text: project.date_updated)
      expect(page).to have_selector('td', text: project.repository_url)
    end
  end

  feature 'Checking a project page' do
    let!(:current_user) { FactoryGirl.create(:user) }

    shared_examples_for 'displaying information about the project' do
      scenario 'displays information about the project' do
        expect(page).to have_selector('h1', text: project.name)
        expect(page).to have_selector('p', text: project.information)
        expect(page).to have_selector('p', text: "By #{project.creator.full_name}")
      end
    end

    context 'when the user is a creator of the project' do
      let!(:project) { FactoryGirl.create(:project, creator: current_user) }

      before do
        login_as(current_user, scope: :user)
        visit project_path(project.id)
      end

      it_behaves_like 'displaying information about the project'

      scenario { expect(page).not_to have_link('Send participation request') }
    end

    context 'when the user is not the creator of the project' do
      let!(:project) { FactoryGirl.create(:project) }

      before do
        login_as(current_user, scope: :user)
        visit project_path(project.id)
      end

      it_behaves_like 'displaying information about the project'

      scenario { expect(page).to have_link('Send participation request') }
    end
  end

  feature 'Searching for a project by a project name' do
    before { visit projects_path }

    context 'when there aren\'t any existing projects' do
      before do
        within 'form.simple_form.form-inline' do
          fill_in('search_project_name', with: 'projectname')
          click_button('Go!')
        end
      end

      scenario { expect(page).to have_selector('h3', text: '0 results found.') }
    end

    context 'when the search input is empty' do
      let(:flash_notification_warning) { 'Please, input something in the search field!' }

      before do
        within 'form.simple_form.form-inline' do
          click_button('Go!')
        end
      end

      scenario { expect(page).to have_selector('.alert.alert-warning', text: flash_notification_warning) }
    end

    context 'when there are registered users' do
      let!(:project_1) { FactoryGirl.create(:project, name: 'Project One') }
      let!(:project_2) { FactoryGirl.create(:project, name: 'Project Two') }

      context 'but there aren\'t any project names matching the provided search input' do
        before do
          within 'form.simple_form.form-inline' do
            fill_in('search_project_name', with: 'projectname')
            click_button('Go!')
          end
        end

        scenario { expect(page).to have_selector('h3', text: '0 results found.') }
      end

      context 'and there are project names matching the provided search input' do
        before do
          within 'form.simple_form.form-inline' do
            fill_in('search_project_name', with: 'One')
            click_button('Go!')
          end
        end

        scenario 'displays a table with the results' do
          expect(page).to have_link(project_1.name)
          expect(page).to have_selector('td', text: project_1.information)
          expect(page).to have_link(project_1.creator.full_name)
          expect(page).to have_selector('td', text: project_1.date_created)
          expect(page).to have_selector('td', text: project_1.date_updated)
          expect(page).to have_link(project_1.repository_url)
        end

        scenario { expect(page).to have_selector('h3', text: '1 result found.') }
      end
    end
  end
end
