class StatusCheck
  attr_accessor :github_client, :full_name, :repo_name, :base_sha, :merge_sha, :number, :git_url, :payload

  def initialize(payload)
    @full_name = payload['pull_request']['base']['repo']['full_name']
    @repo_name = payload['pull_request']['base']['repo']['name']
    @base_sha = payload['pull_request']['base']['sha']
    @base_ref = payload['pull_request']['base']['ref']
    @merge_sha = payload['pull_request']['head']['sha']
    @merge_ref = payload['pull_request']['head']['ref']
    @number = payload['pull_request']['number']
    @payload = payload
  end

  def check
    create_status('Checking for offenses...')
    repo_path = setup_repo

    current_warnings_output = `cd #{repo_path} && git checkout #{merge_sha} && #{check_command}`
    

    current_warnings = parse_output_for_info(current_warnings_output)

    store_data({ sha: merge_sha,
                 merge_branch_rubocop_warnings: 0,
                 this_branch_rubocop_warnings: current_warnings,
                 rubocop_output: current_warnings_output,
                 number: number} )

    puts 'stored data'

    if current_warnings.to_i > 0
      puts 'failed'
      new_offenses = current_warnings.to_i
      failed_status("#{new_offenses} offenses have been added.",
                    "http://bob-morton.grahamhadgraft.co.uk:3000/patch/#{full_name}/#{number}")
    else
      puts 'succeeded'
      successful_status('No new offenses added')
    end

    FileUtils.rm_rf(repo_path)
  rescue
    FileUtils.rm_rf(repo_path)
  end

  private

  def submit_status_check
    false
  end

  def github_client
    @client ||= Octokit::Client.new(login: ENV['GITHUB_USERNAME'], password: ENV['GITHUB_PASSWORD'])
  end

  def create_status(message)
    return unless send_status_check?

    github_client.create_status(full_name, merge_sha, :pending, context: check_name, description: message)
  end

  def failed_status(description, url)
    return unless send_status_check?

    github_client.create_status(full_name, merge_sha, :failure, context: check_name, description: description, target_url: url)
  end

  def successful_status(description)
    return unless send_status_check?

    github_client.create_status(full_name, merge_sha, :success, context: check_name, description: description)
  end

  def setup_repo
    puts git_url
    unless File.directory? "/tmp/#{repo_name}_#{check_name}_#{number}"
      `git clone https://#{ENV['GITHUB_USERNAME']}:#{ENV['GITHUB_PASSWORD']}@github.com/#{full_name}.git /tmp/#{repo_name}_#{check_name}_#{number}`
    end

    `cd /tmp/#{repo_name}_#{check_name}_#{number} && git pull`

    "/tmp/#{repo_name}_#{check_name}_#{number}"
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
