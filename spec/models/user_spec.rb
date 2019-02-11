require 'rails_helper'

RSpec.describe User, type: :model do
  let(:priority) { 0 }
  let!(:user) { build(:user, priority: priority) }

  context 'instance methods' do
    describe '#regular?' do
      let(:priority) { 1 }

      it 'responds to :regular?' do
        expect(user).to respond_to(:regular?)
      end

      it 'checks given user is a regular one' do
        expect(user).to be_regular
      end
    end

    describe '#admin?' do
      let(:priority) { 3 }

      it 'responds to :admin?' do
        expect(user).to respond_to(:admin?)
      end

      it 'checks given user is a admin one' do
        expect(user).to be_admin
      end
    end
  end
end
