class AddSoftDeleteToProjectEnvironments < ActiveRecord::Migration[6.1]
  def change
    add_column :zeus_service_engine_project_environments, :deleted_at, :datetime, null: true
    add_index :zeus_service_engine_project_environments, :deleted_at
  end
end
