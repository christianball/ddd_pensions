class CreateContributions < ActiveRecord::Migration[6.0]
  def change
    create_table :contributions do |t|
      t.string :employee_name, null: false
      t.date :starts_on, null: false
      t.date :ends_on, null: false
      t.integer :amount, null: false
      t.string :currency, null: false
      t.string :state, null: false, default: 'created'
      t.timestamps
    end
  end
end
