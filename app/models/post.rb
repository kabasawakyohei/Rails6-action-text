class Post < ApplicationRecord
  has_rich_text :content
  validates :title, length: { maximum: 9 }, presence :true
end
