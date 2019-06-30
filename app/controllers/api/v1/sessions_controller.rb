class Api::V1::SessionsController < Devise::SessionsController
  before_action :sign_in_params, only: :create
  before_action :load_user,  only: :create
  before_action :valid_token, only: :destroy
  skip_before_action :verify_signed_out_user, only: :destroy

	def create
		if @user.valid_password?(sign_in_params[:password])
			sign_in "user", @user
			json_response "signed In successfully", true,  {user: @user}, :ok
		else
            json_response "Un authorized", false,  {}, :unauthorized
		end
	end

	def destroy
		sign_out @user
		@user.generate_new_access_token
		json_response "Log out successfully", true, {}, :ok
	end


    private

	def sign_in_params
		params.require(:sign_in).permit(:email, :password)
	end

	def load_user
		@user = User.find_for_database_authentication(email: sign_in_params[:email])
		if @user
			return @user
		else
			json_response "Cannot get user", false, {}, :failure
		end
	end

	def valid_token
		@user = User.find_by authentication_token: request.headers["AUTH-TOKEN"]
		if @user
			return @user
		else
			json_response "Invalid Token", false, {}, :failure
		end
	end


end