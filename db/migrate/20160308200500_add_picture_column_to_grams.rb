class AddPictureColumnToGrams < ActiveRecord::Migration
  def change
    add_column :grams, :picture, :string
  end
end
