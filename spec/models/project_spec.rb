require 'rails_helper'

describe Project do
  let(:project) { FactoryGirl.build(:project) }

  let(:valid_repository_link) { 'https://github.com/test/test' }
  let(:invalid_repository_link) { 'www.github.com/test/test' }

  it { expect(subject).to have_many(:project_participations) }
  it { expect(subject).to have_many(:users).through(:project_participations) }
  it { expect(subject).to have_many(:announcements).dependent(:destroy) }
  it { expect(subject).to belong_to(:creator).with_foreign_key(:creator_id).class_name('User') }

  it { expect(subject).to allow_value('').for(:repository_link) }
  it { expect(subject).to allow_value(valid_repository_link).for(:repository_link) }
  it { expect(subject).not_to allow_value(invalid_repository_link).for(:repository_link) }

  describe '#repository_url' do
    context 'when the repository_link is present' do
      let(:repository_url) { '/test/repository' }

      it { expect(project.repository_url).to eq(repository_url) }
    end

    context 'when there is no repository_link' do
      before { project.repository_link = nil }

      it { expect(project.repository_url).to eq '' }
    end
  end

  describe 'Timestamp stringify methods' do
    let(:stringified_timestamp) { '01 January 2016' }

    before(:all) { Timecop.freeze(Time.local(2016, 1, 1, 12)) }
    after(:all) { Timecop.return }

    describe '#date_created' do
      it { expect(project.date_created).to eq(stringified_timestamp) }
    end

    describe '#date_updated' do
      it { expect(project.date_updated).to eq(stringified_timestamp) }
    end
  end
end
