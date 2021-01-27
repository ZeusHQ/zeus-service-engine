module Zeus
  module Service
    module Engine
      class ApplicationController < ActionController::Base
        before_action :authorize_api_request!
        skip_before_action :verify_authenticity_token

        private
        def render_struct(s)
          render json: {success?: s.success?, errors: s.errors}
        end

        def authorize_api_request!
          result = AuthCommands::AuthorizeApiRequest.call(request.headers, cookies)
          if result.success?
            if result.payload.present?
              @current_env ||= result.payload.env if result.payload.env
              @current_permissions ||= result.payload.permissions if result.payload.permissions
            else
              @current_permissions ||= "zeus"
            end
          else
            render_struct(result) and return false
          end
        end

        def current_env
          @current_env
        end

        def current_permissions
          @current_permissions
        end
      end
    end
  end
end
