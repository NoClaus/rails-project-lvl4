class AddErrorCountToRepositoryCheck < ActiveRecord::Migration[6.1]
  def change
    add_column :repository_checks, :error_count, :integer
  end
end
