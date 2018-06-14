class BrakemanCheck < StatusCheck
  private

  def check_name
    'brakeman'
  end

  def check_command
    'pronto run --runner=brakeman --formatters=json --commit=develop'
  end

  def send_status_check?
    true
  end

  def parse_output_for_info(command_output)
    json_output = JSON.parse(command_output)
    json_output.length
  end

  def store_data(options)
    commit = Commit.find_or_create_by(sha: options[:sha], number: options[:number])
    commit.save!

    JSON.parse(options[:rubocop_output]).each do |warning|
      Warning.create!(source: 'brakeman',
                      filename: warning['path'],
                      line_number: warning['line'],
                      description: warning['message'],
                      log_level: warning['level'],
                      commit_id: commit.id)
    end
  end
end
