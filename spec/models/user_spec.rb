require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    context "success" do
      let(:user) { create(:user) }

      it "has a valid factory" do
        expect(user).to be_valid
      end

      it "is valid with a ban_status of 0" do
        user = build(:user, ban_status: 0)
        expect(user).to be_valid
      end

      it "is valid with a ban_status of 1" do
        user = build(:user, ban_status: 1)
        expect(user).to be_valid
      end
    end

    context "failure" do
      it "is invalid without a idfa" do
        user = build(:user, idfa: nil)
        user.valid?
        expect(user.errors[:idfa]).to include("can't be blank")
      end

      it "is invalid with a duplicate idfa" do
        user = create(:user, idfa: "8264148c-be95-4b2b-b260-6ee98dd53bf1")
        other_user = build(:user, idfa: user.idfa)
        other_user.valid?
        expect(other_user.errors[:idfa]).to include("has already been taken")
      end

      it "is invalid without a ban_status" do
        user = build(:user, ban_status: nil)
        user.valid?

        expect(user.errors[:ban_status]).to include("can't be blank")
      end

      it "is invalid with ban_status nil value" do
        user = build(:user, ban_status: nil)
        user.valid?

        expect(user.errors[:ban_status]).to include("is not included in the list")
      end

      it "is invalid with a ban_status not in the enum list" do
        expect { build(:user, ban_status: 3) }.to raise_error(ArgumentError)
      end
    end
  end
end
