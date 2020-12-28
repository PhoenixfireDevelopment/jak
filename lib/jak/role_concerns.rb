# frozen_string_literal: true

# The Jak module.
module Jak
  # The Role Concerns
  module RoleConcerns
    extend ActiveSupport::Concern

    included do
      if defined?(Jak.tenant_klass) && Jak.tenant_klass.present?
        if Jak.roles_foreign_key.present?
          belongs_to Jak.tenant_klass.model_name.singular.to_sym, class_name: Jak.tenant_klass.to_s, foreign_key: Jak.roles_foreign_key.to_s
        else
          belongs_to Jak.tenant_klass.model_name.singular.to_sym, class_name: Jak.tenant_klass.to_s
        end
      end

      has_many :powers, dependent: :destroy, class_name: Jak.power_klass.to_s
      has_many :users, through: :powers, class_name: Jak.user_klass.to_s

      before_validation :generate_key, unless: ->(role) { role.name.blank? }

      after_destroy :pull_role_id_from_grant

      def to_param
        "#{id}-#{name}".parameterize
      end

      def self.key_column?
        Jak.role_klass.column_names.include?('key')
      end

      # TODO: Cache me
      def grants(eager = false)
        result = Jak::Grant.where(:role_ids.in => [id])
        eager ? result.to_a : result
      end

      # TODO: Cache me
      def grant_ids
        grants.pluck(:id)
      end

      # TODO: Cache me
      def permissions(eager = false)
        result = Jak::Permission.where(:id.in => permission_ids)
        eager ? result.to_a : result
      end

      # TODO: Cache me
      def permission_ids
        grants.pluck(:permission_id)
      end

      def permission_ids=(my_permission_ids = [])
        my_permission_ids.each do |permission_id|
          my_grant = Jak::Grant.find_or_initialize_by(permission: permission_id)

          # Add this unless it already exists
          next unless my_grant.present?

          my_grant.role_ids ||= []
          my_grant.role_ids.push(id) unless my_grant.role_ids.include?(id)
          my_grant.save
        end
      end

      private

      def generate_key
        return false unless self.class.key_column?
        return false if key.present?

        self.key = name.parameterize if self.class.key_column?
      end

      def pull_role_id_from_grant
        grants(true).each do |grant|
          grant.pull(role_ids: id)
          grant.destroy if grant.role_ids.empty?
        end
      end
    end

    # The class methods for the Role Concerns
    module ClassMethods
      # TODO: so how does this limit it to the right company?
      # Find a role by its key
      # @param key [String] The key for the Role.
      def get(key)
        # TODO:
        # tenant_id_column = "#{Jak.tenant_id_column}_id"
        if Jak.role_klass.column_names.include?('key')
          find_by(key: key)
        else
          find_by(name: key)
        end
      end
    end
  end
end
