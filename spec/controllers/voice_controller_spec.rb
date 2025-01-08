# frozen_string_literal: true

require 'spec_helper'

describe VoiceController, type: :controller do
  shared_examples 'correct response' do
    it 'returns correct response status and body' do
      expect(response.status).to eq expected_status
      expect(parsed_body).to match expected_body
    end
  end

  context 'with invalid params' do
    context 'with missing param' do
      before { post :create, params: params }

      let(:params) do
        {
          user_id: 1,
          from: '123456',
          to: '65321'
        }
      end
      let(:expected_status) { 422 }
      let(:expected_body) { { success: false, message: 'Missing value for text' } }

      include_examples 'correct response'
    end

    context 'with non-existing did' do
      before do
        user
        post :create, params: params
      end

      let(:user) { FactoryBot.create(:user) }
      let(:params) do
        {
          user_id: user.id,
          from: '123456',
          to: '65321',
          text: 'test'
        }
      end
      let(:expected_status) { 404 }
      let(:expected_body) { { success: false, message: 'Did specified in from not found on your account' } }

      include_examples 'correct response'
    end

    context "with another user's did" do
      before do
        user
        did
        post :create, params: params
      end

      let(:user) { FactoryBot.create(:user) }
      let(:another_user) { FactoryBot.create(:user) }
      let(:did) { FactoryBot.create(:did, user: another_user) }
      let(:params) do
        {
          user_id: user.id,
          from: did.number,
          to: '65321',
          text: 'test'
        }
      end
      let(:expected_status) { 404 }
      let(:expected_body) { { success: false, message: 'Did specified in from not found on your account' } }

      include_examples 'correct response'
    end
  end

  context 'with valid params' do
    before do
      did
      post :create, params: params
    end

    let(:user) { FactoryBot.create(:user) }
    let(:did) { FactoryBot.create(:did, user: user) }
    let(:params) do
      {
        user_id: user.id,
        from: did.number,
        to: '65321',
        text: 'test'
      }
    end
    let(:expected_status) { 201 }
    let(:expected_body) { { success: true } }

    include_examples 'correct response'
  end
end
