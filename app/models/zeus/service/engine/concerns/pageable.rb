module Zeus::Service::Engine::Concerns::Pageable
    extend ActiveSupport::Concern

    included do
        attr_accessor :page, :per_page, :order
    end

    def paged_scope(scope)
        scope.page(self.cleaned_page).per(self.cleaned_per_page).order(self.cleaned_order)
    end

    def cleaned_order
        @cleaned_order ||= "#{self.class.name.split("::").first.gsub("Commands", "").tableize}.created_at desc"
    end
    
    def cleaned_page
        @cleaned_page ||= [MIN_PAGE, (page || MIN_PAGE).to_i].max
    end

    def cleaned_per_page
        @cleaned_per_page ||= [MAX_PER_PAGE, [MIN_PER_PAGE, (per_page || MIN_PER_PAGE).to_i].max].min
    end

    def total
        @total ||= default_scope.count
    end

    def num_pages
        @num_pages ||= (@total / cleaned_per_page.to_f).ceil
    end
end