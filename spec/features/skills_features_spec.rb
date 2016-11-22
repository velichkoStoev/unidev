require 'rails_helper'

describe 'Skills Features' do
  let!(:current_user) { FactoryGirl.create(:user) }

  before { login_as(current_user, scope: :user) }

  feature 'User checks their skills' do
    let!(:skill) { FactoryGirl.create(:skill) }
    let!(:user_skill) { FactoryGirl.create(:user_skill, skill: skill, user: current_user) }

    before { visit edit_user_path(current_user.id) }

    scenario 'they see a panel with the names of their skills' do
      expect(page).to have_selector('.panel-heading', text: 'My skills')
      expect(page).to have_selector('.btn-toolbar span', text: skill.name)
      expect(page).to have_link('Delete')
    end
  end

  feature 'User adds a skill', js: true do
    context 'when they add a new skill' do
      before do
        visit edit_user_path(current_user.id)

        within('#new_skill') do
          fill_in('skill_name', with: 'Testing')
          click_button('Add')
        end
      end

      scenario { expect(page).to have_selector('.btn-toolbar span', text: 'Testing') }
    end

    context 'when they try to add an existing skill' do
      let!(:skill) { FactoryGirl.create(:skill, name: 'Testing') }
      let!(:user_skill) { FactoryGirl.create(:user_skill, skill: skill, user: current_user) }

      before do
        visit edit_user_path(current_user.id)

        within('#new_skill') do
          fill_in('skill_name', with: 'Testing')
          click_button('Add')
        end
      end

      scenario { expect(page).to have_selector('.help-block', text: 'You already have this skill') }
    end

    context 'when they try to add empty skill name' do
      before do
        visit edit_user_path(current_user.id)

        within('#new_skill') do
          fill_in('skill_name', with: '')
          click_button('Add')
        end
      end

      scenario { expect(page).to have_selector('.help-block', text: 'can\'t be blank') }
    end
  end

  feature 'User deletes a skill', js: true do
    let!(:skill_1) { FactoryGirl.create(:skill, name: 'Testing') }
    let!(:skill_2) { FactoryGirl.create(:skill, name: 'Refactoring') }
    let!(:user_skill_1) { FactoryGirl.create(:user_skill, skill: skill_1, user: current_user) }
    let!(:user_skill_2) { FactoryGirl.create(:user_skill, skill: skill_2, user: current_user) }

    before do
      visit edit_user_path(current_user.id)

      within("#skill_#{skill_2.id}") do
        click_link('Delete')
      end
    end

    scenario { expect(page).to have_selector("#skill_#{skill_1.id}") }
    scenario { expect(page).not_to have_selector("#skill_#{skill_2.id}") }
  end
end
