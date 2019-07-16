require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to(:voteable) }
  it { should belong_to(:user) }
  it { should validate_presence_of :vote }
  it { should validate_inclusion_of(:vote).in_array([-1, 1]) }
  it { should validate_uniqueness_of(:user_id).scoped_to(:voteable_type, :voteable_id) }
end