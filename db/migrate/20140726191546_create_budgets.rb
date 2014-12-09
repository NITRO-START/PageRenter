class CreateBudgets < ActiveRecord::Migration
  def change
    create_table :budgets do |t|
      t.boolean :active, null: false
      t.integer :value, limit: 8, null: false
      t.string :operator_url, limit: 140, null: true
      t.datetime :closed_date, null: true
      t.integer :id_on_operator, null: true
      t.belongs_to :currency, index: true, null: false
      t.belongs_to :campaign, index: true, null: false
      t.belongs_to :card_flag, index: true, null: false
      t.belongs_to :recurrence_period, index: true, null: false

      t.timestamps
    end
  end
end
