# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Note do
  describe 'validations' do
    subject { build(:note) }

    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:body) }
  end

  describe 'database columns' do
    it { is_expected.to have_db_column(:archived).of_type(:boolean).with_options(default: false, null: false) }
  end
end
