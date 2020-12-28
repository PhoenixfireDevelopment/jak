# frozen_string_literal: true

json.array! @permissions, partial: 'jak/permissions/permission', as: :permission
