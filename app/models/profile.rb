require 'rqrcode'

class Profile < ApplicationRecord
  belongs_to :user
  
  has_one_attached :profile_picture
  has_one_attached :background_picture
  
  validates :user, presence: true
  
  # Find a profile by its share_id
  def self.find_by_share_id(share_id)
    find_by(share_id: share_id)
  end
  
  # Generate a shareable URL for this profile
  def shareable_url
    host = Rails.application.config.action_mailer.default_url_options[:host]
    port = Rails.application.config.action_mailer.default_url_options[:port]
    base_url = port ? "#{host}:#{port}" : host
    "#{Rails.application.routes.url_helpers.share_profile_url(host: base_url)}?id=#{share_id}"
  end
  
  # Generate a QR code for the shareable URL
  def qr_code(size: 300)
    qrcode = RQRCode::QRCode.new(shareable_url)
    
    # Return the QR code as an SVG
    qrcode.as_svg(
      color: '000',
      shape_rendering: 'crispEdges',
      module_size: size / qrcode.modules.size,
      standalone: true,
      use_path: true
    )
  end
end
