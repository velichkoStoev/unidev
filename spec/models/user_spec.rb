require 'rails_helper'

describe User do
  let(:user) { FactoryGirl.build(:user) }

  let(:email_validation_message) { 'The e-mail domain must be @unidev.com' }
  let(:valid_email) { 'valid@unidev.com' }
  let(:invalid_email) { 'invalid' }

  it { expect(subject).to have_many(:project_participations) }
  it { expect(subject).to have_many(:projects).through(:project_participations) }
  it { expect(subject).to have_many(:created_projects).with_foreign_key(:creator_id).class_name('Project') }
  it { expect(subject).to have_many(:user_skills) }
  it { expect(subject).to have_many(:skills).through(:user_skills) }
  it { expect(subject).to have_many(:announcements).dependent(:destroy) }
  it { expect(subject).to have_many(:sent_messages).with_foreign_key(:sender_id).class_name('Message') }
  it { expect(subject).to have_many(:received_messages).with_foreign_key(:receiver_id).class_name('Message') }

  it { expect(subject).to have_attached_file(:avatar) }

  it 'validates the content type of the avatar' do
    expect(subject).to validate_attachment_content_type(:avatar)
      .allowing('image/png', 'image/jpeg')
  end

  it { expect(subject).to validate_presence_of(:first_name) }
  it { expect(subject).to validate_presence_of(:last_name) }
  it { expect(subject).to validate_presence_of(:faculty) }
  it { expect(subject).to validate_presence_of(:email) }
  it { expect(subject).to allow_value(valid_email).for(:email).with_message(email_validation_message) }
  it { expect(subject).not_to allow_value(invalid_email).for(:email).with_message(email_validation_message) }

  describe '#full_name' do
    let(:user_full_name) { 'Test Testing' }

    it { expect(user.full_name).to eq user_full_name }
  end

  describe 'Timestamp stringify methods' do
    let(:stringified_timestamp) { '01 January 2016' }

    before(:all) { Timecop.freeze(Time.utc(2016, 1, 1, 12)) }
    after(:all) { Timecop.return }

    describe '#birthday' do
      it { expect(user.birthday).to eq(stringified_timestamp) }
    end

    describe '#date_created' do
      it { expect(user.date_created).to eq(stringified_timestamp) }
    end

    describe '#date_last_updated' do
      it { expect(user.date_last_updated).to eq(stringified_timestamp) }
    end
  end
end
