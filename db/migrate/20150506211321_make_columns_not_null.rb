class MakeColumnsNotNull < ActiveRecord::Migration
  def change
    change_column :shortened_urls, :long_url, :string, null: false
    change_column :shortened_urls, :short_url, :string, null: false
    change_column :shortened_urls, :submitter_id, :integer, null: false

    change_column :users, :email, :string, null: false
  end
end
