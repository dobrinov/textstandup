class Team < ApplicationRecord
  validates :name, presence: true

  has_and_belongs_to_many :members, class_name: 'User', join_table: 'members_teams', association_foreign_key: 'member_id'
  has_and_belongs_to_many :admins, class_name: 'User', join_table: 'admins_teams', association_foreign_key: 'admin_id'
end
