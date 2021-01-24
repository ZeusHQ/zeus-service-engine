class CreateZeusServiceEngineProjectEnvironments < ActiveRecord::Migration[6.1]
  def change
    create_table :zeus_service_engine_project_environments, id: :uuid do |t|
      t.uuid :project_id
      t.string :encrypted_secret_key
      t.string :public_key

      t.timestamps
    end

    add_index :zeus_service_engine_project_environments, :project_id
    add_index :zeus_service_engine_project_environments, :public_key
  end
end
