class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :encrypted_personal_access_token
      t.string :encrypted_personal_access_token_iv

      t.timestamps
    end
  end
end
