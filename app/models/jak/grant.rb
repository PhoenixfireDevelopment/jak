# frozen_string_literal: true

# The Jak module
module Jak
  # The "joins" table between Permissions and Roles
  class Grant
    include Mongoid::Document
    field :role_ids, type: Array
    belongs_to :permission

    validates :permission, presence: true

    # TODO: Cache Me
    # Retrieves the roles back from ActiveRecord
    def roles
      Jak.role_klass.where(id: role_ids)
    end

    # Sets the role ID's. Requires an array of ActiveRecord objects
    def roles=(my_roles = [])
      self.role_ids = my_roles.pluck(:id)
    end
  end
end
