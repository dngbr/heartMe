class AddShareIdToProfiles < ActiveRecord::Migration[8.0]
  def change
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')
    add_column :profiles, :share_id, :uuid, default: 'gen_random_uuid()', null: false
    add_index :profiles, :share_id, unique: true
  end
end
