# frozen_string_literal: true

##
# The User
class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable,
         :validatable, :confirmable, :lockable, authentication_keys: [:name]

  has_many :projects, dependent: :destroy
  has_many :artifacts
  has_many :passages

  attribute :security_answer
  attribute :question_id
  attribute :terms

  validates :name, presence: true, length: { maximum: 30 },
            uniqueness:      { case_sensitive: false }

  validates_acceptance_of :terms

  validates_with SecurityQuestionValidator, on: :save
  validate :password_complexity

  def password_complexity
    if password.present? && (not password.match(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)./))
      errors.add :password, "must include at least one lowercase letter, one uppercase letter, and one digit."
    end
  end

  protected

    def confirmation_required?
      if Rails.env == "development" || Rails.env == "test"
        false
      else
        true
      end
    end
end
