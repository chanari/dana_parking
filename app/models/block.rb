class Block < ApplicationRecord
  belongs_to :floor
  has_many :parking_slots, dependent: :destroy
  accepts_nested_attributes_for :parking_slots, reject_if: :all_blank

  before_save :build_parking_slots

  attr_accessor :slots

  private

  def build_parking_slots
    if self.slots.present?
      self.slots.to_i.times do |n|
        self.parking_slots.build(name: "#{self.name}0#{n+1}")
      end
    end
  end

end
