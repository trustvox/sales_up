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

    describe '#am?' do
      let(:sub_area) { 'am' }

      it 'responds to :am?' do
        expect(user).to respond_to(:am?)
      end

      it 'checks given user is a account manager one' do
        expect(user).to be_am
      end
    end

    describe '#sdr?' do
      let(:sub_area) { 'sdr' }

      it 'responds to :sdr?' do
        expect(user).to respond_to(:sdr?)
      end

      it 'checks given user is a sales representative one' do
        expect(user).to be_sdr
      end
    end

    describe '#spectator?' do
      let(:sub_area) { 'spec' }

      it 'responds to :admin?' do
        expect(user).to respond_to(:spectator?)
      end

      it 'checks given user is a spectator one' do
        expect(user).to be_spectator
      end
    end

    describe '#fn?' do
      let(:sub_area) { 'fn' }

      it 'responds to :fn?' do
        expect(user).to respond_to(:fn?)
      end

      it 'checks given user is a financial one' do
        expect(user).to be_fn
      end
    end

    describe '#ra?' do
      let(:sub_area) { 'ra' }

      it 'responds to :ra?' do
        expect(user).to respond_to(:ra?)
      end

      it 'checks given user is a Reclame Aqui user one' do
        expect(user).to be_ra
      end
    end
  end
end
