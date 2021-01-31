class AddPropertiesToProjectEnvironments < ActiveRecord::Migration[6.1]
  def change
    add_column :zeus_service_engine_project_environments, :properties, :jsonb, null: false, default: {}
  end
end
