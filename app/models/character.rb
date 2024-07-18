class Character < ApplicationRecord
  belongs_to :user
  belongs_to :universe
  belongs_to :race, optional: true
  belongs_to :univers_class, optional: true

  has_many :notes
  has_many :party_characters
  has_many :parties, through: :party_characters

  has_one_attached :photo

  def update_completion_rate
    rate = 0
    rate += 1 if self.universe.present?
    rate += 1 if self.race.present?
    rate += 1 if self.univers_class.present?
    rate += 1 if self.strength.present?
    rate += 1 if self.dexterity.present?
    rate += 1 if self.intelligence.present?
    rate += 1 if self.constitution.present?
    rate += 1 if self.wisdom.present?
    rate += 1 if self.charisma.present?
    self.update(completion_rate: rate)
  end
end
