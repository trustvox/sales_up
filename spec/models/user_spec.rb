require 'rails_helper'

RSpec.describe User, type: :model do
  let(:area) { 'spec' }
  let(:sub_area) { 'spec' }
  let!(:user) { build(:user, area: area, sub_area: sub_area) }

  context 'instance methods' do
    describe '#overall_manager?' do
      let(:area) { 'gg' }

      it 'responds to :overall_manager?' do
        expect(user).to respond_to(:overall_manager?)
      end

      it 'checks given user is a overall manager one' do
        expect(user).to be_overall_manager
      end
    end

    describe '#sales?' do
      let(:area) { 'sales' }

      it 'responds to :sales?' do
        expect(user).to respond_to(:sales?)
      end

      it 'checks given user is from sales one' do
        expect(user).to be_sales
      end
    end

    describe '#admin?' do
      let(:sub_area) { 'admin' }

      it 'responds to :admin?' do
        expect(user).to respond_to(:admin?)
      end

      it 'checks given user is a admin one' do
        expect(user).to be_admin
      end
    end
  end
end
