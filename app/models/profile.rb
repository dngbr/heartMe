require 'rqrcode'
require 'base64'
require 'openssl'

class Profile < ApplicationRecord
  belongs_to :user
  
  has_one_attached :profile_picture
  has_one_attached :background_picture
  
  validates :user, presence: true
  
  def self.find_by_share_id(share_id)
    find_by(share_id: share_id)
  end
  
  def secure_shareable_url
    host = Rails.application.config.action_mailer.default_url_options[:host]
    port = Rails.application.config.action_mailer.default_url_options[:port]
    base_url = port ? "#{host}:#{port}" : host
    encrypted_id = EncryptionHelper.encrypt_share_id(self.share_id)
    "#{Rails.application.routes.url_helpers.shared_profile_url(code: encrypted_id, host: base_url)}"
  end
  
  def secure_qr_code(size: 300)
    qrcode = RQRCode::QRCode.new(secure_shareable_url)
    qrcode.as_svg(
      color: '000',
      shape_rendering: 'crispEdges',
      module_size: size / qrcode.modules.size,
      standalone: true,
      use_path: true
    )
  end
end
