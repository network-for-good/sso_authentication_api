module SsoAuthenticationApi
  class TokenDecoder
    # Passing 'true' to the public_key method will attempt to decode the token
    # against a secondary cert if one exists.
    require "jwt"

    def self.decode(token)
      options = { algorithm: 'RS256' }
      JWT.decode(token, public_key, true, options)
    rescue
      JWT.decode(token, public_key(true), true, options)
    end

    def self.public_key(use_secondary_cert = false)
      certificate(use_secondary_cert).public_key
    end

    def self.cert_file_path(use_secondary_cert = false)
      File.join(Rails.root, 'config', 'public_key_certs', cert_file_name(use_secondary_cert))
    end

    def self.cert_file_name(use_secondary_cert = false)
      secondary_name = use_secondary_cert ? "_secondary" : ""
      case Rails.env
      when 'test', 'qa', 'development'
        "nfg_qa#{ secondary_name }.cer"
      else
        "nfg_production#{ secondary_name }.cer"
      end
    end

    def self.certificate(use_secondary_cert = false)
      OpenSSL::X509::Certificate.new(File.read(cert_file_path(use_secondary_cert)))
    end

  end

end