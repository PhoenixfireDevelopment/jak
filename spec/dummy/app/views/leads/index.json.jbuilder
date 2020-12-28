# frozen_string_literal: true

json.array! @leads, partial: 'leads/lead', as: :lead
