class Block < ApplicationRecord
  belongs_to :floor
  has_many :parking_slots, dependent: :destroy
  accepts_nested_attributes_for :parking_slots, reject_if: :all_blank

  before_save :update_name
  before_save :build_parking_slots

  attr_accessor :slots

  private

  def update_name
    self.name = "#{self.floor.name}-#{self.name}"
  end

  def build_parking_slots
    if self.slots.present?
      self.slots.to_i.times do |n|
        if n < 9
          self.parking_slots.build(name: "#{self.name}0#{n+1}")
        else
          self.parking_slots.build(name: "#{self.name}#{n+1}")
        end
      end
    end
  end

end
