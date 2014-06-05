class SocialNetwork < ActiveRecord::Base
  # Relations
  has_many :social_sessions

  # Attrs validations
  validates :name, presence: true, length: { in: 3..50 }, on: [:create, :update]
  validates :acronym, length: { in: 3..10 }, on: [:create, :update]
  validates :description, length: { in: 3..45 }, on: [:create, :update]

  # Validates Associations
end
