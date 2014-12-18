require 'rails_helper'

RSpec.describe User, :type => :model do
  it 'has a valid factory' do
    create(:user).should be_valid
  end

  it 'requires an email' do
    build(:user, email: nil).should_not be_valid
  end
end
