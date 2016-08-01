class PatchController < ApplicationController
  before_action :authenticate_user!
  def index
    client = Octokit::Client.new(:login => ENV['GITHUB_USERNAME'], :password => ENV['GITHUB_PASSWORD'])

    @response = client.pull_files("#{params[:user]}/#{params[:repo]}", params[:pr_number])

    @warnings = Commit.last.rubocop_output.split("\n")
  end
end