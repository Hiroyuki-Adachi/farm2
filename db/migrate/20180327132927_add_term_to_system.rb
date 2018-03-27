require 'date'

class AddTermToSystem < ActiveRecord::Migration
  def up
    add_column :systems, :start_date, :date, {null: true, comment: "期首日"}
    add_column :systems, :end_date, :date, {null: true, comment: "期末日"}

    System.all.each do |system|
      system.start_date = Date.new(system.term, 1, 1)
      system.end_date = Date.new(system.term, 12, 31)

      system.save!
    end

    change_column_null :systems, :start_date, false
    change_column_null :systems, :end_date, false
  end

  def down
    remove_column :systems, :start_date
    remove_column :systems, :end_date
  end
end
