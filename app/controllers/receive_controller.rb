class ReceiveController < ApplicationController
  skip_before_action :verify_authenticity_token

  def receive
    payload = JSON.parse(params[:payload])

    if payload['action'] == 'opened' || payload['action'] == 'synchronize'
      user = payload['pull_request']['head']['user']['login']
      repo = payload['pull_request']['head']['repo']['name']
      branch = payload['pull_request']['head']['ref']
      sha = payload['pull_request']['head']['sha']
      number = payload['pull_request']['number']

      project = Project.find_by(github_project_user: user, github_project_name: repo)
      branch = project.branches.find_or_create_by!(name: branch)
      commit = Commit.find_or_create_by(branch_id: branch.id, sha: sha, number: number)
      commit.warnings.delete_all

      RubocopWorker.perform_async(payload)
      BrakemanWorker.perform_async(payload)
      RailsBestPracticesWorker.perform_async(payload)
      ReekWorker.perform_async(payload)
    end

    render plain: "Job kicked off"
  end
end
