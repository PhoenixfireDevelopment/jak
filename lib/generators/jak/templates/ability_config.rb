# frozen_string_literal: true

# app/models/jak_ability.rb

# Our custom implementation of Jak's MyAbility
class Ability < Jak::MyAbility
  include CanCan::Ability

  def initialize(resource)
    # Load the permissions from MyAbility
    super do
      # Indicate what Namespaces are yielded to here
      # yield_namespace('frontend')
      # yield_namespace('backend')
    end

    # Let the dummies always see their dashboard.
    can :index, :dashboard
  end
end
