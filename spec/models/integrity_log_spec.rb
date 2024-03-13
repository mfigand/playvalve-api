require 'rails_helper'

RSpec.describe IntegrityLog, type: :model do
  describe 'validations' do
    context "success" do
      let(:integrity_log) { create(:integrity_log) }

      it "has a valid factory" do
        expect(integrity_log).to be_valid
      end

      it "is valid with a ban_status of 0" do
        integrity_log = build(:integrity_log, ban_status: 0)
        expect(integrity_log).to be_valid
      end

      it "is valid with a ban_status of 1" do
        integrity_log = build(:integrity_log, ban_status: 1)
        expect(integrity_log).to be_valid
      end
    end

    context "failure" do
      it "is invalid without a idfa" do
        integrity_log = build(:integrity_log, idfa: nil)
        integrity_log.valid?
        expect(integrity_log.errors[:idfa]).to include("can't be blank")
      end

      it "is invalid without a ban_status" do
        integrity_log = build(:integrity_log, ban_status: nil)
        integrity_log.valid?

        expect(integrity_log.errors[:ban_status]).to include("can't be blank")
      end

      it "is invalid with ban_status nil value" do
        integrity_log = build(:integrity_log, ban_status: nil)
        integrity_log.valid?

        expect(integrity_log.errors[:ban_status]).to include("can't be blank")
      end

      it "is invalid with a ban_status not in the enum list" do
        expect { build(:integrity_log, ban_status: 3) }.to raise_error(ArgumentError)
      end
    end
  end
end
