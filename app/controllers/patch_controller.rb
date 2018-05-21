class PatchController < ApplicationController
  before_action :authenticate_user!
  def index
    client = Octokit::Client.new(:login => ENV['GITHUB_USERNAME'], :password => ENV['GITHUB_PASSWORD'])

    @response = client.pull_files("#{params[:user]}/#{params[:repo]}", params[:pr_number])

    @rubocop_warnings = Commit.where(number: params[:pr_number]).last.rubocop_output.split("\n")
    brakeman_warnings = Commit.where(number: params[:pr_number]).last
    if brakeman_warnings
      @brakeman_warnings = JSON.parse(brakeman_warnings.brakeman_output)
    end
  end
end
