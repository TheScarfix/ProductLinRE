# frozen_string_literal: true

class EditorController < ApplicationController
  before_action :authenticate_user!

  def index
    @projects = Project.all

    @artifacts = Artifact.all.order(updated_at: :desc).limit(9)
    # list last 9 own projects in home
    @home_projects = @projects.limit(9)

    # list last 5 own projects in left sidebar
    @own_projects = @projects.where(user_id: current_user.id)
                        .order(updated_at: :desc).limit(5)

    # list last 5 projects from other users in left sidebar
    @other_projects = @projects.where.not(user_id: current_user.id)
                          .order(updated_at: :desc)

    # list own project's features in features overview
    @current_project = @projects.find_by_id(params[:project])

    if params[:project]
      session[:cur_project_id] = params[:project]
    end
  end
end
