# frozen_string_literal: true

# Base abstract object for ActiveRecord classes
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
