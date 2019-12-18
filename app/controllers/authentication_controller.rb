class AuthenticationController < ApplicationController

    def login
        @user = User.find_by(username: params[:username])

        puts params[:username]

        if (!@user)
            render status: :unauthorized
        else
            if (@user.authenticate(params[:password]))
                secret_key = Rails.application.credentials.dig(:secret_key_base)
                # secret_key = Rails.application.secrets.secret_key_base[0]
                token = JWT.encode({
                    user_id: @user.id,
                    username: @user.username,
                    exp: Time.now.to_i + 3600,
                }, secret_key)

                render json: { token: token }
            else
                render status: :unauthorized
            end
        end
    end

end