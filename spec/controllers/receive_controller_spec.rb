require 'rails_helper'

RSpec.describe ReceiveController, type: :controller do
  describe 'GET #receive' do
    context 'with a synchronize payload' do
      let(:payload) { File.read('spec/fixtures/synchronize-pr.json') }
      before do
        allow(RubocopWorker).to receive(:perform_async)
        allow(BrakemanWorker).to receive(:perform_async)
      end

      it 'returns http success' do
        create(:project, :bob_morton)

        get :receive, params: { payload:payload }
        expect(response).to have_http_status(:success)
      end

      it 'returns text to say the job has been kicked off' do
        create(:project, :bob_morton)

        get :receive, params: { payload: payload }
        expect(response.body).to eq 'Job kicked off'
      end

      it 'creates a branch' do
        project = create(:project, :bob_morton)

        expect{
          get :receive, params: { payload: payload }
        }.to change{ project.reload.branches.count }.from(0).to(1)
      end
    end
  end
end
