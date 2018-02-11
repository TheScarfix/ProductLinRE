class CreateSecurityQuestion < ActiveRecord::Migration[5.2]
  def change
    create_table :security_questions do |t|
      t.string :locale
      t.string :question
      t.string :answer
    end
  end
end
