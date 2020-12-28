# frozen_string_literal: true

# The Jak module
module Jak
  # Represents the singleton set of Permissions
  class Permission
    include Mongoid::Document
    field :action, type: String
    field :klass, type: String
    field :description, type: String
    field :namespace, type: String
    field :restricted, type: Mongoid::Boolean

    has_many :grants, foreign_key: :permission_id, class_name: 'Jak::Grant', dependent: :destroy

    validates :action, :klass, :description, :namespace, presence: true

    scope :with_klass, ->(klass) { where(klass: klass) }
    scope :with_namespace, ->(namespace) { where(namespace: namespace) }
    scope :restricted, -> { where(restricted: true) }
    scope :unrestricted, -> { where(restricted: false) }
    scope :with_action, ->(action) { where(action: action) }
    scope :with_actions, ->(actions) { where(:action.in => actions) }

    # Find out what roles this Permission has
    def roles
      Jak.role_klass.where(id: grants.pluck(:role_ids).compact.flatten)
    end

    # Find out what Role IDs this Permission has
    def role_ids
      roles.pluck(:id)
    end

    # String representation
    def to_s
      description
    end

    # TODO: when this is deleted, it should update the RoleSet permission_ids
  end
end
