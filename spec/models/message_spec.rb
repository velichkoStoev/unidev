require 'rails_helper'

describe Message do
  let(:message) { FactoryGirl.build(:message) }

  it { expect(subject).to belong_to(:sender).with_foreign_key(:sender_id).class_name('User') }
  it { expect(subject).to belong_to(:receiver).with_foreign_key(:receiver_id).class_name('User') }

  it { expect(subject).to validate_presence_of(:title) }
  it { expect(subject).to validate_presence_of(:body) }
  it { expect(subject).to validate_presence_of(:sender_id) }
  it { expect(subject).to validate_presence_of(:receiver_id) }

  describe 'Timestamp stringify methods' do
    let(:stringified_timestamp) { '12:00, 01.Jan.2016' }

    before(:all) { Timecop.freeze(Time.utc(2016, 1, 1, 12)) }
    after(:all) { Timecop.return }

    describe '#date_created' do
      it { expect(message.date_created).to eq(stringified_timestamp) }
    end
  end
end
