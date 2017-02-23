class SharesController < ApplicationController
	def create
		user = User.find_by(email: params[:receiving_email])
		sitter = user.sitters.new(sitter_params)
		if sitter.save
			login(user)
			redirect_to sitters_path
		else
			flash.now[:errors] = sitter.errors.full_messages
			redirect_to sitters_path
		end
	end

	def sitter_params
		params
	      .permit(
	        :paid,
	        :hourly_rate,
	        :phone,
	        :email,
	        :name,
	        :can_drive,
	        :ord,
	        :per_extra_kid
	      )
	  end
end
