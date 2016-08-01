class OpenedRubocopWorker
  include Sidekiq::Worker

  def perform(payload)
    full_name = payload['pull_request']['base']['repo']['full_name']
    repo_name = payload['pull_request']['base']['repo']['name']
    base_sha = payload['pull_request']['base']['sha']
    merge_sha = payload['pull_request']['head']['sha']
    number = payload['pull_request']['number']

    puts "Repo" + full_name
    puts "PR:" + number.to_s
    puts payload

    client = Octokit::Client.new(:login => ENV['GITHUB_USERNAME'], :password => ENV['GITHUB_PASSWORD'])

    client.create_status(full_name, merge_sha, :pending, context: 'RuboCop', description: 'Checking offenses...')

    unless File.directory? "/tmp/#{repo_name}"
      `git clone #{payload["repository"]["git_url"]} /tmp/#{repo_name}`
    end

    `cd /tmp/#{repo_name} && git pull`

    initial_warnings_output = `cd /tmp/#{repo_name} && git checkout #{base_sha} && rubocop`
    current_warnings_output = `cd /tmp/#{repo_name} && git checkout #{merge_sha} && rubocop`

    initial_warnings = /, (.*?) offenses detected/.match(initial_warnings_output.split("\n").last)[1]
    current_warnings = /, (.*?) offenses detected/.match(current_warnings_output.split("\n").last)[1]

    puts current_warnings_output

    initial_warnings = 0 if initial_warnings == 'no'
    current_warnings = 0 if current_warnings == 'no'

    commits = Commit.new(sha: merge_sha, 
                         merge_branch_rubocop_warnings: initial_warnings, 
                         this_branch_rubocop_warnings: current_warnings, 
                         rubocop_output: current_warnings_output,
                         number: number)
    commits.save!

    puts initial_warnings
    puts current_warnings

    if initial_warnings.to_i < current_warnings.to_i
      new_offenses = current_warnings.to_i - initial_warnings.to_i
      client.create_status(full_name, merge_sha, :failure, context: 'RuboCop', description: "#{new_offenses} new offenses have been added. (#{current_warnings} total offenses)", target_url: "http://bob-morton.grahamhadgraft.co.uk/patch/#{full_name}/#{number}")
    else
      reduced_offenses = initial_warnings.to_i - current_warnings.to_i
      client.create_status(full_name, merge_sha, :success, context: 'RuboCop', description: "#{reduced_offenses} offenses have been removed. (#{current_warnings} total offenses)", target_url: "http://bob-morton.grahamhadgraft.co.uk/patch/#{full_name}/#{number}")
    end
  end
end