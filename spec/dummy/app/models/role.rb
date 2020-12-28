# frozen_string_literal: true

# User roles
class Role < ApplicationRecord
  belongs_to :company

  validates :name, uniqueness: { case_sensitive: false, scope: [:company_id] }, presence: true
  validates :company, presence: true

  scope :ordered, -> { order(name: :asc) }
end
