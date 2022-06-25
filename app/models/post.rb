class Post < ApplicationRecord
  has_rich_text :content
  validates :title, length: { maximum: 9 }, presence: true
  validate :validate_content_attachment_byte_size
  
  # リッチテキスト内の文字数バリデーションを実装する
  MAX_CONTENT_LENGTH = 10
  validate :validate_content_length

  def validate_content_length
    length = content.to_plain_text.length

    if length > MAX_CONTENT_LENGTH
      errors.add(
        :content, 
        :too_long, 
        max_content_length: MAX_CONTENT_LENGTH,
        length: length,
)
    end
  end

  # リッチテキスト内の画像サイズのバリデーションを実装する


  MAX_CONTENT_LENGTH = 50
  ONE_KILOBYTE = 1024
  MEGA_BYTES = 3
  MAX_CONTENT_ATTACHMENT_BYTE_SIZE = MEGA_BYTES * 1_000 * ONE_KILOBYTE

  # 配列に格納されている画像サイズをそれぞれ抽出する
  
  def validate_content_attachment_byte_size
    content.body.attachables.grep(ActiveStorage::Blob).each do |attachable|
      if attachable.byte_size > MAX_CONTENT_ATTACHMENT_BYTE_SIZE
        errors.add(
          :base,
          :content_attachment_byte_size_is_too_big,
          max_content_attachment_mega_byte_size: MEGA_BYTES,
          bytes: attachable.byte_size,
          max_bytes: MAX_CONTENT_ATTACHMENT_BYTE_SIZE,
        )
      end
     end
  end
end
