module Zeus::Service::Engine::Concerns::Pageable
    extend ActiveSupport::Concern

    included do
        attr_accessor :page, :per_page, :order
    end

    def paged_scope(scope)
        scope.page(self.cleaned_page).per(self.cleaned_per_page).order(self.cleaned_order)
    end

    def cleaned_order
        DEFAULT_ORDER
    end
    
    def cleaned_page
        [MIN_PAGE, (page || MIN_PAGE).to_i].max
    end

    def cleaned_per_page
        [MAX_PER_PAGE, [MIN_PER_PAGE, (per_page || MIN_PER_PAGE).to_i].max].min
    end
end