require 'rails_helper'

RSpec.describe ReceiveController, type: :controller do
  describe 'GET #receive' do
    before do
      allow(RubocopWorker).to receive(:perform_async)
      allow(BrakemanWorker).to receive(:perform_async)
    end

    it 'returns http success' do
      get :receive, params: { payload: '{ "action": "opened" }' }
      expect(response).to have_http_status(:success)
    end

    it 'returns text to say the job has been kicked off' do
      get :receive, params: { payload: '{ "action": "opened" }' }
      expect(response.body).to eq 'Job opened kicked off'
    end
  end
end
