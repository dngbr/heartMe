module EncryptionHelper
  # Encrypt a share_id for use in QR codes
  def self.encrypt_share_id(share_id)
    # Encrypt the share_id
    cipher = OpenSSL::Cipher.new('aes-256-gcm')
    cipher.encrypt
    key = Rails.application.secret_key_base[0..31] # Use first 32 bytes of secret_key_base as key
    cipher.key = key
    iv = cipher.random_iv
    
    encrypted = cipher.update(share_id) + cipher.final
    tag = cipher.auth_tag
    
    # Combine IV, tag, and encrypted data and encode as Base64
    combined = iv + tag + encrypted
    Base64.urlsafe_encode64(combined)
  end
  
  # Decrypt an encrypted share_id
  def self.decrypt_share_id(encrypted_id)
    begin
      # Decode from Base64
      combined = Base64.urlsafe_decode64(encrypted_id)
      
      # Extract IV, tag, and encrypted data
      iv = combined[0..11]        # IV is 12 bytes for GCM
      tag = combined[12..27]      # Auth tag is 16 bytes
      encrypted = combined[28..-1] # The rest is the encrypted data
      
      # Decrypt
      decipher = OpenSSL::Cipher.new('aes-256-gcm')
      decipher.decrypt
      key = Rails.application.secret_key_base[0..31] # Use first 32 bytes of secret_key_base as key
      decipher.key = key
      decipher.iv = iv
      decipher.auth_tag = tag
      
      # Decrypt and return the share_id
      decipher.update(encrypted) + decipher.final
    rescue => e
      Rails.logger.error("Error decoding encrypted share_id: #{e.message}")
      nil
    end
  end
end
