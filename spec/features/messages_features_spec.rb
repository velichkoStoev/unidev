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

  feature 'User reads a message', js: true do
    let!(:received_message) { FactoryGirl.create(:message, receiver: current_user) }

    before do
      login_as(current_user, scope: :user)
      visit user_messages_path(current_user.id)
      click_link(received_message.title)
    end

    scenario 'they see the content of the message' do
      expect(page).to have_selector('.message .panel.panel-heading', text: 'Message')
      expect(page).to have_selector('.container-fluid .list-group-item', text: received_message.title)
      expect(page).to have_selector('.container-fluid .list-group-item', text: received_message.body)
    end

    context 'when the user has unread messages' do
      scenario { expect(page).to have_selector('tr.warning') }
    end

    context 'when the user has no unread messages' do
      scenario { expect(page).not_to have_selector('tr.warning') }
    end
  end

  feature 'User composes a message', js: true do
    before do
      login_as(current_user, scope: :user)
      visit user_messages_path(current_user.id)
      click_link('Compose new message')
    end

    scenario 'they see a form for composing a new message' do
      expect(page).to have_selector('.message_title label.control-label', text: 'Title')
      expect(page).to have_selector('.message_title input')
      expect(page).to have_selector('.message_body label.control-label', text: 'Body')
      expect(page).to have_selector('.message_body textarea')
      expect(page).to have_selector('.message_receiver_id label.control-label', text: 'Receiver')
      expect(page).to have_selector('.message_receiver_id select')
      expect(page).to have_button('Sent')
    end
  end
end
