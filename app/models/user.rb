class User < ApplicationRecord
  STATUSES = { banned: 0, not_banned: 1 }.freeze

  enum ban_status: STATUSES

  validates :idfa, presence: true, uniqueness: true
  validates :ban_status, presence: true, inclusion: { in: ban_statuses.keys }
end
