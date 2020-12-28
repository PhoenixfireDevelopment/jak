# frozen_string_literal: true

# A lead for business. Assigned to a specific user, and only them.
class Lead < ApplicationRecord
  belongs_to :assignable, class_name: 'User'
  belongs_to :company

  validates :name, uniqueness: { case_sensitive: false }, presence: true
  validates :company, presence: true

  scope :ordered, -> { order(name: :asc) }

  # How do we represent a lead as a string?
  def to_s
    name
  end
end
