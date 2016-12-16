require 'nfg_jwt_token_security/secure_api'

module SsoAuthenticationApi::V1
  module Admins
    class AuthenticationsController < ActionController::Base
      include SsoAuthenticationApi::TokenAuthentication

      before_filter :authorize_nfg_request!

      skip_before_filter :redirect_on_inactive_entity
      before_filter :load_admin

      respond_to :json

      def create
        # byebug
        render(json: { errors: "Request must include an email param"}, status: 500) and return if params[:email].nil?
        render(json: { errors: "Admin could not be found"}, status: 404) and return unless @admin

        respond_with  @admin, serializer: SsoAuthenticationApi::V1::AdminSerializer, location: nil, status: @status
      end


    private

      def skip_track_action
        # no reason to add ahoy event records for api requests
        true
      end

      def load_admin
        admins = Admin.where(email: params[:email])
        return if admins.empty?
        if @admin = first_authenticated_admin(admins)
          @status = 200
        else
          @admin = admins.first
          @status = 401
        end
      end

      def first_authenticated_admin(admins)
        # return the first admin that can be authenticated using the passed password
        admins.select { |admin| authenticate_user(admin, params[:password]) }.first
      end

      def authenticate_user(admin, password)
        admin.valid_password?(password)
      end
    end
  end
end
