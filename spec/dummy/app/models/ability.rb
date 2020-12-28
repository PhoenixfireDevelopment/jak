# frozen_string_literal: true

# app/models/jak_ability.rb

# TODO: more detailed specs for this. Lookup how CanCanCan deals with Class vs. Instance permissions
# Our custom implementation of Jak's MyAbility
class Ability < Jak::MyAbility
  include CanCan::Ability

  # NOTE: you could have a "team_namespace" where it would deal with shared resources for your team
  # as well as an "individual_namespace" which deals with resources which are namespace *specifically*
  # to this Ability user record. That way, you get the best of all worlds.
  # The Namespaces for which to yield for this specific Ability (UserAbility)
  NAMESPACES_TO_YIELD = %w[dummy dummy_manager].freeze

  def initialize(resource)
    # Load the permissions from MyAbility
    super do
      NAMESPACES_TO_YIELD.each { |namespace| yield_namespace(namespace) }
    end

    # Let the dummies always see their dashboard.
    can :index, :dashboard
  end
end
