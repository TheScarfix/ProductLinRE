# frozen_string_literal: true

json.extract! artifact, :id, :name, :filename, :created_at, :updated_at
json.url artifact_url(artifact, format: :json)
