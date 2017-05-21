require 'rails_helper'

RSpec.describe Todo, type: :model do

  # Association test (1 to many with Item)
  it { should have_many(:items).dependent(:destroy) }

  # Validation test
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:created_by) }
end
