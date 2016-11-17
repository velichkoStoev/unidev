require 'rails_helper'

describe 'Messages Features' do
  let!(:current_user) { FactoryGirl.create(:user) }

  feature 'User checks their messages' do
    let!(:sent_message) { FactoryGirl.create(:message, sender: current_user) }
    let!(:received_message) { FactoryGirl.create(:message, receiver: current_user) }

    before do
      login_as(current_user, scope: :user)
      visit user_messages_path(current_user.id)
    end

    scenario 'they see their inbox' do
      expect(page).to have_selector('.panel-heading', text: 'Inbox')
      expect(page).to have_selector('td', text: received_message.date_created)
      expect(page).to have_selector('td', text: received_message.title)
      expect(page).to have_selector('td', text: received_message.body)
      expect(page).to have_selector('td', text: received_message.sender.full_name)
    end

    scenario 'they see their sent messages box' do
      expect(page).to have_selector('.panel-heading', text: 'Sent messages')
      expect(page).to have_selector('td', text: sent_message.date_created)
      expect(page).to have_selector('td', text: sent_message.title)
      expect(page).to have_selector('td', text: sent_message.body)
      expect(page).to have_selector('td', text: sent_message.sender.full_name)
    end

    scenario { expect(page).to have_link('Compose new message', href: new_user_message_path(current_user.id)) }
  end

  feature 'User reads a specific message' do
    before do
      login_as(current_user, scope: :user)
      visit user_messages_path(current_user.id)
    end
  end
end
