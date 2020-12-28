# frozen_string_literal: true

require 'mongoid'
require 'set'
require 'jbuilder'

# Most of the details for the base JAK namespace live here
require 'jak/configuration'

# ===================================================================
# Middleware loader for JAK
# ===================================================================

# Proxy
require 'jak/middleware/proxy'

# ===================================================================
# ===================================================================

# Load the rails gem engine
require 'jak/engine'

# Our stuff
require 'jak/core/dsl'
require 'jak/core/constraint_manager'
require 'jak/core/constraint'
require 'jak/core/namespace_manager'
require 'jak/core/namespace'
require 'jak/core/rolesets'
require 'jak/core/role_set'
require 'jak/jak_ability'
require 'jak/my_ability'
require 'cancan'

# TODO: should this be conditional?
require 'pry'

# Defines out the master namespace and functionality
# @!attribute namespace_manager
#   The default Namespace Manager singleton which manages all declared namespaces.
# @!attribute constraint_manager
#   Singleton which manages all the Constraints which are parsed from the DSL.
# @!attribute invokers
#   An distinct array of classes that have invoked a call to the DSL.
# @!attribute rolesets
#   Singleton that contains all the Pre-defined Role Sets
# @!attribute dsl_profile_path
#   The file path of what DSL Profile file to load
module Jak
  # Have to extend Configuration first so we have our module variables
  extend Configuration

  # Autoload all our monkey-patching files
  autoload :RoleConcerns, 'jak/role_concerns'
  autoload :TenantConcerns, 'jak/tenant_concerns'

  # The singleton manages the Namespaces
  def self.namespace_manager
    Core::NamespaceManager.instance
  end

  # ConstraintManager: Maintains a list of all the constraints.
  def self.constraint_manager
    Core::ConstraintManager.instance
  end

  # The singleton which holds the Pre-defined Role Sets
  def self.rolesets
    Core::Rolesets.instance
  end

  # TODO: cache invalidator hooks (don't solve, just create hooks)

  # Reset everything.
  def self.clear!
    invokers.clear
    constraint_manager.send(:clear!)
    namespace_manager.send(:clear!)
    rolesets.send(:clear!)
  end

  # shortcut
  def self.dsl(&block)
    raise ArgumentError, '`dsl` requires a block argument' unless block_given?

    ::Jak::Core::DSL.define(&block)
  end
end
