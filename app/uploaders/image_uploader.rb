class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  # 保存先を切り替え
  case Rails.env
    when 'production'
      storage :fog
    when 'development'
      storage :fog
    when 'test'
      storage :file
  end

  # 保存ディレクトリを指定
  def store_dir
    "#{Rails.env}/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # 画像は300pxにリサイズ
  process :resize_to_limit => [300, 300]

  # アップロード出来るファイルを限定
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  # 保存形式をjpgとする
   process :convert => 'jpg'

   # ファイル名を日付に変更
   def filename
     if original_filename.present?
       time = Time.now
       name = time.strftime('%Y%m%d%H%M%S') + '.jpg'
       name.downcase
     end
   end
end
