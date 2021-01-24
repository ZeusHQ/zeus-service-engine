module Zeus::Service::Engine::Concerns::Sluggable
    extend ActiveSupport::Concern

    included do
        validates :slug, presence: true, uniqueness: true
        before_validation :create_slug, on: :create

        SLUG_ORIGIN_FIELD = :name
    end
    
    def create_slug
        if self.send(SLUG_ORIGIN_FIELD).present?
            slug = self.send(SLUG_ORIGIN_FIELD).parameterize
            x = 1
            if self.class.send(:"exists?", slug: slug)
                begin
                    slug = "#{self.send(SLUG_ORIGIN_FIELD).parameterize}-#{x}"
                    x += 1
                end while self.class.send(:"exists?", slug: slug)
            end
            self.send(:"slug=", slug)
        end
    end

end