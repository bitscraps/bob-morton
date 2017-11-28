class StatusCheck
  attr_accessor :github_client, :full_name, :repo_name, :base_sha, :merge_sha, :number, :git_url, :payload

  def initialize(payload)
    @full_name = payload['pull_request']['base']['repo']['full_name']
    @repo_name = payload['pull_request']['base']['repo']['name']
    @base_sha = payload['pull_request']['base']['sha']
    @merge_sha = payload['pull_request']['head']['sha']
    @number = payload['pull_request']['number']
    @payload = payload
  end

  def check
    create_status('Checking for offenses...')
    repo_path = setup_repo

    puts "cd #{repo_path} && git checkout #{base_sha} && #{check_command}"
    initial_warnings_output = `cd #{repo_path} && git checkout #{base_sha} && #{check_command}`
    puts "cd #{repo_path} && git checkout #{merge_sha} && #{check_command}"
    current_warnings_output = `cd #{repo_path} && git checkout #{merge_sha} && #{check_command}`

    puts 'outputs received'

    initial_warnings = parse_output_for_info(initial_warnings_output)

    puts 'parsed initial output'
    current_warnings = parse_output_for_info(current_warnings_output)
    puts 'parsed final output'

    puts 'storing data'

    store_data({ sha: merge_sha,
                 merge_branch_rubocop_warnings: initial_warnings,
                 this_branch_rubocop_warnings: current_warnings,
                 rubocop_output: current_warnings_output,
                 number: number} )

    puts 'stored data'

    puts initial_warnings
    puts current_warnings

    if initial_warnings.to_i < current_warnings.to_i
      puts 'failed'
      new_offenses = current_warnings.to_i - initial_warnings.to_i
      failed_status("#{new_offenses} offenses have been added. (#{current_warnings} total offenses)",
                    "http://bob-morton.herokuapp.co.uk/patch/#{full_name}/#{number}")
    else
      puts 'succeeded'
      reduced_offenses = initial_warnings.to_i - current_warnings.to_i
      successful_status("#{reduced_offenses} offenses have been removed. (#{current_warnings} total offenses)")
    end
  end

  private

  def github_client
    @client ||= Octokit::Client.new(login: ENV['GITHUB_USERNAME'], password: ENV['GITHUB_PASSWORD'])
  end

  def create_status(message)
    github_client.create_status(full_name, merge_sha, :pending, context: check_name, description: message)
  end

  def failed_status(description, url)
    client.create_status(full_name, merge_sha, :failure, context: check_name, description: description, target_url: url)
  end

  def successful_status(description)
    client.create_status(full_name, merge_sha, :success, context: check_name, description: description)
  end

  def setup_repo
    puts git_url
    unless File.directory? "/tmp/#{repo_name}_#{check_name}"
      `git clone https://#{ENV['GITHUB_PASSWORD']}@github.com/sofarsounds/sofar-main.git /tmp/#{repo_name}_#{check_name}`
    end

    `cd /tmp/#{repo_name}_brakeman && git pull`

    "/tmp/#{repo_name}_#{check_name}"
  end

  def store_data(options)
  end

  def check_name
    raise NoMethodError, 'Subclasses of StatusCheck must implement #check_name'
  end

  def check_command
    raise NoMethodError, 'Subclasses of StatusCheck must implement #check_command'
  end

  def parse_output_for_info(output)
    raise NoMethodError, 'Subclasses of StatusCheck must implement #parse_output_for_info'
  end
end