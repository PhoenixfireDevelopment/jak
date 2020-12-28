# frozen_string_literal: true

# Company record for multi-tenant application
class Company < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :roles, dependent: :destroy
  has_many :leads, dependent: :destroy

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  scope :ordered, -> { order(name: :asc) }

  # How do we convert this company to a string?
  def to_s
    name
  end
end
