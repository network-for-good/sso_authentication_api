class CreateAdmin < ActiveRecord::Migration[6.1]
  def change
    create_table :admins do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :sso_id
      t.string :status
      t.string :roles
      
      t.timestamps
    end
  end
end
