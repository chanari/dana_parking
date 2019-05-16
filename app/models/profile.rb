class Profile < ApplicationRecord
  validates :phone, length: { is: 14 }

  belongs_to :user
end
