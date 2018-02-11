# frozen_string_literal: true

json.extract! project, :id, :name, :user_id, :created_at, :updated_at, :orig_project_id
json.url project_url(project, format: :json)
