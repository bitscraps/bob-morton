class PatchController < ApplicationController
  before_action :authenticate_user!

  def index
    @response = github_files
    @sources = params.key?(:source) ? params[:source] : ['rubocop', 'brakeman', 'rails_best_practices', 'reek']

    @last_commit = Commit.where(number: params[:pr_number]).last
  end

  def client
    @client ||= Octokit::Client.new(login: ENV['GITHUB_USERNAME'],
                                    password: ENV['GITHUB_PASSWORD'])
  end

  def last_commit
    @last_commit ||= Commit.where(number: params[:pr_number]).last
  end

  def github_files
    client.pull_files("#{params[:user]}/#{params[:repo]}", params[:pr_number])
  end
end
