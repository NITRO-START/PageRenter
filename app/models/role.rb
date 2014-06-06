class Role < ActiveRecord::Base
  # Relations
  has_many :profiles

  # Attrs validations
  validates :name, presence: true, length: { in: 5..15 }, on: [:create, :update]

  # Validates Associations
end
