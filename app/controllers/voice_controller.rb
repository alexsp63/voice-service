# frozen_string_literal: true

class VoiceController < ApplicationController
  before_action :check_params, :check_user_did, only: :create

  def create
    render json: { success: true }, status: 201
  end

  private

  def check_params
    required_params = %w[user_id from to text]
    param_values = params.permit(*required_params).to_h
    missing_params = required_params - param_values.keys
    return if missing_params.blank?

    render json: { success: false, message: "Missing value for #{missing_params.first}" }, status: 422
  end
end
