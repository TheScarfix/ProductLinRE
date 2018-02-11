# frozen_string_literal: true

class SecurityQuestionValidator < ActiveModel::Validator
  def validate(record)
    unless SecurityQuestion.find(record.question_id).answer == record.security_answer.downcase
      if locale == "en"
        record.errors[:question] << "Wrong answer"
      end
    end
  end
end
