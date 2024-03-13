class IntegrityLog < ApplicationRecord
  enum ban_status: User::STATUSES

  validates :idfa, :ban_status, :ip, presence: true
end
