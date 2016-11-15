require 'rails_helper'

describe ProjectParticipation do
  it { expect(subject).to belong_to(:user) }
  it { expect(subject).to belong_to(:project) }

  it { expect(subject).to validate_presence_of(:user) }
  it { expect(subject).to validate_presence_of(:project) }
end
