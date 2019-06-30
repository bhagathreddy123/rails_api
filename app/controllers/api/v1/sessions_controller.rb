class Api::V1::SessionsController < Devise::SessionsController
  before_action :sign_in_params, only: :create
  before_action :load_user,  only: :create
	def create
		if @user.valid_password?(sign_in_params[:password])
			sign_in "user", @user
			json_response "signed In successfully", true,  {user: @user}, :ok
		else
            json_response "Un authorized", false,  {}, :unauthorized
		end
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
end