require 'rails_helper'

describe UserSkill do
  it { expect(subject).to belong_to(:user) }
  it { expect(subject).to belong_to(:skill) }

  it { expect(subject).to validate_presence_of(:user) }
  it { expect(subject).to validate_presence_of(:skill) }

  it { expect(subject).to validate_uniqueness_of(:user_id).scoped_to(:skill_id) }
end
