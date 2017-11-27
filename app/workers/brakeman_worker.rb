class BrakemanWorker
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

    client.create_status(full_name, merge_sha, :pending, context: 'Brakeman', description: 'Checking Security Vulnerabilities...')

    unless File.directory? "/tmp/#{repo_name}"
      `git clone #{payload["repository"]["git_url"]} /tmp/#{repo_name}_brakeman`
    end

    `cd /tmp/#{repo_name}_brakeman && git pull`

    initial_warnings_output = `cd /tmp/#{repo_name}_brakeman && git checkout #{base_sha} && bundle exec rubocop`
    current_warnings_output = `cd /tmp/#{repo_name}_brakeman && git checkout #{merge_sha} && bundle exec rubocop`

    initial_warnings = JSON.parse(initial_warnings_output)['scan_info']['security_warnings']
    current_warnings = JSON.parse(current_warning_output)['scan_info']['security_warnings']

    puts current_warnings_output

    initial_warnings = 0 if initial_warnings == 'no'
    current_warnings = 0 if current_warnings == 'no'

    puts initial_warnings
    puts current_warnings

    if initial_warnings.to_i < current_warnings.to_i
      new_offenses = current_warnings.to_i - initial_warnings.to_i
      client.create_status(full_name, merge_sha, :failure, context: 'Brakeman', description: "#{new_offenses} vulnerabilities have been added. (#{current_warnings} total vulnerabilities)", target_url: "http://bob-morton.grahamhadgraft.co.uk:3000/patch/#{full_name}/#{number}")
    else
      reduced_offenses = initial_warnings.to_i - current_warnings.to_i
      client.create_status(full_name, merge_sha, :success, context: 'Brakeman', description: "#{reduced_offenses} vulnerabilities have been removed. (#{current_warnings} total vulnerabilities)", target_url: "http://bob-morton.grahamhadgraft.co.uk:3000/patch/#{full_name}/#{number}")
    end
  end
end