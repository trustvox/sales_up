require 'rails_helper'

RSpec.describe Contract, type: :model do
  context 'validate' do
    subject { FactoryBot.build(:contract) }

    describe 'presence of attributes' do
      it { should validate_presence_of(:day) }
      it { should validate_presence_of(:store_name) }
      it { should validate_presence_of(:value) }
    end

    describe 'numericality formar of attributes' do
      it { should validate_numericality_of(:day) }
      it { should validate_numericality_of(:value) }
    end

    describe 'store name minimun and maximun length' do
      it { expect(subject.store_name.length).to(be >= 2) && (be <= 100) }
    end
  end

  context 'instance methods' do
    describe 'responds to' do
      let!(:contract) { FactoryBot.build(:contract) }

      it ':month_days_of_report' do
        expect(contract).to respond_to(:month_days_of_report)
      end

      it ':last_day_of_month' do
        expect(contract).to respond_to(:last_day_of_month)
      end

      it ':report_record' do
        expect(contract).to respond_to(:report_record)
      end
    end
  end
end
