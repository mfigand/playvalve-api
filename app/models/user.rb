class User < ApplicationRecord
  enum ban_status: [:banned, :not_banned]

  validates :idfa, presence: true, uniqueness: true
  validates :ban_status, presence: true, inclusion: { in: ban_statuses.keys }
end
