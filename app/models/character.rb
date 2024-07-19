class Character < ApplicationRecord
  belongs_to :user
  belongs_to :universe
  belongs_to :race, optional: true
  belongs_to :univers_class, optional: true

  has_many :notes
  has_many :party_characters
  has_many :parties, through: :party_characters

  has_one_attached :photo
end
