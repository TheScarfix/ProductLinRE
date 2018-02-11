# frozen_string_literal: true

# This controller handles displaying the User list and single Profiles, the other pages are provided by Devise
class UsersController < ApplicationController
  before_action :authenticate_user!, only: %i[index show]
  before_action :set_user, only: [:show]


  # GET /users
  # GET /users.json
  def index
    @users = User.page(params[:page])
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end
end
