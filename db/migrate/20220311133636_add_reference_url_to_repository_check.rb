class AddReferenceUrlToRepositoryCheck < ActiveRecord::Migration[6.1]
  def change
    add_column :repository_checks, :reference_url, :string
  end
end
