# frozen_string_literal: true

# User records for a company.
class User < ApplicationRecord
  belongs_to :company

  has_many :leads, foreign_key: 'assignable_id'

  validates :name, uniqueness: { case_sensitive: false }, presence: true
  validates :company, presence: true

  scope :ordered, -> { order(name: :asc) }

  # How do we represent a User as a string?
  def to_s
    name
  end
end
