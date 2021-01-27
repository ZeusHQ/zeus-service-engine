module Zeus::Service::Engine
  class ProjectEnvironment < ApplicationRecord
    include Zeus::Service::Engine::Concerns::Encryptable

    validates :public_key, presence: true, uniqueness: true
    validates :encrypted_secret_key, presence: true

    attr_encrypted :secret_key

    before_validation :generate_keys, on: :create

    def as_json(opts={})
      json = {
        id: self.id,
        project_id: self.project_id,
        scope: self.scope,
        created_at: self.created_at,
        updated_at: self.updated_at,
      }
      if opts[:include_keys]
        json[:public_key] = self.public_key
        json[:secret_key] = self.secret_key
      end
      json
    end

    def secret_key
      EncryptionService.decrypt(self.encrypted_secret_key)
    end

    def secret_key=(value)
      self.encrypted_secret_key = EncryptionService.encrypt(value)
    end

    private
    def slug
      Rails.application.class.module_parent.name.clone.gsub("Service", "").downcase.parameterize.gsub(/[^a-z]/, '')
    end

    def generate_keys
      self.secret_key = "sk_" + self.slug + "_" + SecureRandom.urlsafe_base64
      self.public_key = "pk_" + self.slug + "_" + SecureRandom.urlsafe_base64

      if self.class.send(:"exists?", public_key: self.public_key)
        begin
          self.public_key = "pk_" + self.slug + "_" + SecureRandom.urlsafe_base64
        end while self.class.send(:"exists?", public_key: self.public_key)
      end
    end
  end
end
