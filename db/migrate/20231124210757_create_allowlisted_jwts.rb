class CreateAllowlistedJwts < ActiveRecord::Migration[7.1]
  def change
    # standard:disable Rails/CreateTableWithTimestamps
    create_table :allowlisted_jwts do |t|
      t.string :jti, null: false
      t.string :aud
      t.datetime :exp, null: false
      t.references :user, foreign_key: {on_delete: :cascade}, null: false
    end
    # standard:enable Rails/CreateTableWithTimestamps

    add_index :allowlisted_jwts, :jti, unique: true
  end
end
