module Zeus
  module Service
    module Engine
      class ApplicationController < ActionController::Base
        before_action :authorize_api_request!
        skip_before_action :verify_authenticity_token
        around_action :handle_exceptions

        private

        def handle_exceptions
          begin
            yield
          rescue InvalidAuthorization => e
            Rails.logger.error e.message
            render_error(e.message, status=403) && return
          rescue ActiveRecord::RecordNotFound => e
          #   Raven.capture_exception(e)
            render_error(ERROR_RECORD_NOT_FOUND, status=404) && return
          rescue ActiveRecord::RecordInvalid => e
          #   Raven.capture_exception(e)
            render_unprocessable_entity_response(e) && return
          rescue ArgumentError => e
            Rails.logger.error e.message
            Rails.logger.error e.backtrace.join("\n")
            render_error("Invalid request: #{e}.", status=400) && return
          #   Raven.capture_exception(e)
          
          rescue StandardError => e
            Rails.logger.error e.message
            Rails.logger.error e.backtrace.join("\n")
            render_error("Internal server error: #{e}.", status=500) && return
          end
        end

        def render_error(errors, status=200)
          render json: {
            success: false, 
            error: errors.is_a?(Array) ? errors : [errors]
          }, status: status
        end

        def render_resource(resource, type, status=200)
          render json: {
            object: resource,
            success: true,
            type: type,
          }, status: status
        end

        def render_resources(resources, type, total, page, num_pages, status=200)
          render json: {
            objects: resources,
            total: total,
            page: page,
            num_pages: num_pages,
            success: true,
            type: type
          }, status: status
        end

        def require_zeus_permissions!
          if self.current_permissions != PERMISSION_ZEUS
            render_error([ERROR_NOT_AUTHORIZED], status=403) and return false
          end
        end

        def require_private_permissions!
          if self.current_permissions != PERMISSION_ZEUS && self.current_permissions != PERMISSION_PRIVATE
            render_error([ERROR_NOT_AUTHORIZED], status=403) and return false
          end
        end

        def clean_page
          clamp(params[:page], 1, 10000)
        end

        def clean_per_page
          clamp(params[:per_page], 1, 100)
        end

        def clamp(val, min, max)
          [min, [val || min, max].min].max
        end

        def authorize_api_request!
          result = AuthCommands::AuthorizeApiRequest.call(request.headers, cookies)
          
          if result.success?
            @current_env ||= result.payload[:env]
            @current_permissions ||= result.payload[:permissions]
          else
            render_error(result.errors) and return false
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
