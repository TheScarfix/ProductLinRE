# frozen_string_literal: true

json.extract! feature, :id, :name, :description, :created_at, :updated_at
json.url feature_url(feature, format: :json)
