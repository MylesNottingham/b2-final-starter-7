class CreateCoupons < ActiveRecord::Migration[7.0]
  def change
    create_table :coupons do |t|
      t.string :name
      t.string :code
      t.integer :value
      t.boolean :percent_not_dollar
      t.boolean :activation_status, default: true
      t.references :merchant, null: false, foreign_key: true

      t.timestamps
    end
  end
end
