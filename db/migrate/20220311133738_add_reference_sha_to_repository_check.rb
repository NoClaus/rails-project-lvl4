class AddReferenceShaToRepositoryCheck < ActiveRecord::Migration[6.1]
  def change
    add_column :repository_checks, :reference_sha, :string
  end
end
