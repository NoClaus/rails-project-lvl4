class CreateRepositories < ActiveRecord::Migration[6.1]
  def change
    create_table :repositories do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :github_id
      t.string :name
      t.string :full_name
      t.string :link
      t.string :language
      t.datetime :repo_created_at
      t.datetime :repo_updated_at

      t.timestamps
    end
  end
end
