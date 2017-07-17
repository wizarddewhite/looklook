class AddAttachmentToVideo < ActiveRecord::Migration[5.0]
  def change
    add_column :videos, :attachment, :string
  end
end
