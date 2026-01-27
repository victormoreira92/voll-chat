module Api
  module V1
    class UsersController < ApplicationController
      skip_before_action :authenticate

      def login
        user = User.find_by(email: params[:email])
        authenticated_user = user&.authenticate(params[:password])

        if authenticated_user
          token = JsonTokenWeb.encode(user_id: user.id)
          expires_at = JsonTokenWeb.decode(token)[:exp]

          render json: { name: user.name, token: token, expires_at: expires_at }, status: :ok
        else
          render json: { message: I18n.t("errors.invalid_credentials") }, status: :unauthorized
        end
      end
    end
  end
end
