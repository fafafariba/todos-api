require 'rails_helper'

RSpec.describe Item, type: :model do

    # Association
    it { should belong_to(:todo) }

    # Validation
    it { should validate_presence_of(:name) }
end
