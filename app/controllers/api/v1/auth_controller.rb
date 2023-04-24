class Api::V1::AuthController < ApplicationController
    skip_before_action :authorized, only: [:create]


    #User login
    def create
        @user = User.find_by(username: login_params[:username])
        #User#authenticate comes from BCrypt
        if @user&.authenticate(login_params[:password])
            @token = encode_token(user_id: @user.id)
            render json: { user: UserSerializer.new(@user), jwt: @token }, status: :accepted
        else
          render json: { error: 'Enter valid credentials or create a new account' }, status: :unauthorized
        end
      end
    
      private

      def login_params
        # params { user: {username: 'Chandler Bing', password: 'hi' } }
        params.permit(:username, :password)
      end
end
