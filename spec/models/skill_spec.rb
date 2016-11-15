require 'rails_helper'

describe Skill do
  it { expect(subject).to have_many(:user_skills) }
  it { expect(subject).to have_many(:users).through(:user_skills) }

  it { expect(subject).to validate_presence_of(:name) }
  it { expect(subject).to validate_uniqueness_of(:name).case_insensitive }
end
