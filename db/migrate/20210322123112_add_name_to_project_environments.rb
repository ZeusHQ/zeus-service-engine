class AddNameToProjectEnvironments < ActiveRecord::Migration[6.1]
  def change
    add_column :zeus_service_engine_project_environments, :name, :string, null: true
  end
end
