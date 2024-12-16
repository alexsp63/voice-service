# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ActionController::RequestForgeryProtection

  private

  def check_user_did
    user = User.find_by(id: params[:user_id])
    return render json: { success: false, message: 'User not found' }, status: 404 unless user

    return if user.dids.exists?(number: params[:from])

    render json: {
      success: false,
      message: 'Did specified in from not found on your account'
    }, status: 404
  end
end
