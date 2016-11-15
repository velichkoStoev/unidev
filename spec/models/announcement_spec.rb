require 'rails_helper'

describe Announcement do
  it { expect(subject).to belong_to(:user) }
  it { expect(subject).to belong_to(:project) }

  it { expect(subject).to validate_presence_of(:text) }
  it { expect(subject).to validate_length_of(:text).is_at_least(20) }
  it { expect(subject).to validate_presence_of(:user) }
  it { expect(subject).to validate_presence_of(:project) }
end
