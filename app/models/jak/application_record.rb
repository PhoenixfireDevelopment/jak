# frozen_string_literal: true

# Jak namespace
module Jak
  # Base abstract class all ORM models inherit from
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
  end
end
