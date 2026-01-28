module Api
  module V1
    class UsersController < ApplicationController
      skip_before_action :authenticate

      def login
        user = User.find_by(email: user_params[:email])
        authenticated_user = user&.authenticate(user_params[:password])

        if authenticated_user
          token = JsonTokenWeb.encode(user_id: user.id)
          expires_at = JsonTokenWeb.decode(token)[:exp]

          render json: { name: user.name, user_id: user.id, token: token, expires_at: expires_at }, status: :ok
        else
          render json: { message: I18n.t("errors.invalid_credentials") }, status: :unauthorized
        end
      end

    private
      def user_params
        params.require(:user).permit(:email, :password)
      end
    end
  end
end
