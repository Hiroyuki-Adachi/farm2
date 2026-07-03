class AddTermNameToSystems < ActiveRecord::Migration[8.1]
  def change
    add_column :systems, :term_name, :string, limit: 10, null: false, default: ''

    System.reset_column_information
    System.find_each do |system|
      system.update_column(:term_name, system.term.to_s)
    end
  end
end
