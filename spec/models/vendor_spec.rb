require 'rails_helper'

RSpec.describe Vendor, type: :model do
  context "Checked vendors name" do
    it 'Vendor has name' do
      vendor = Vendor.new(title: 'Hello')
      expect(vendor).to be_valid 
    end

    it 'Vendor has not name' do
      vendor = Vendor.new
      expect(vendor).not_to be_valid
    end
  end
end
