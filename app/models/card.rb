class Card < ActiveRecord::Base

  has_many :launches, as: :launchable
  belongs_to :account

  enum brand: %w(mastercard visa america_express diners aura elo hipercard)

  def self.human_model_name
    self.model_name.human
  end

end
