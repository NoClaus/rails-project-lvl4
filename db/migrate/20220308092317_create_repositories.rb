class CreateRepositories < ActiveRecord::Migration[6.1]
  def change
    create_table :repositories do |t|
      t.references :user, null: false, foreign_key: true
      t.string :github_id
      t.string :repo_name
      t.string :language
      
      t.timestamps
    end
  end
end
