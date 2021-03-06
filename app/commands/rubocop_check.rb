class RubocopCheck < StatusCheck
  private

  def check_name
    'rubocop'
  end

  def check_command
    "pronto run --runner=rubocop --formatters=json --commit=#{base_ref}"
  end

  def send_status_check?
    true
  end

  def parse_output_for_info(command_output)
    output = JSON.parse(command_output)
    output.length
  end

  def store_data(options)
    commit = Commit.find_or_create_by(sha: options[:sha], number: options[:number])

    JSON.parse(options[:rubocop_output]).each do |warning|
      warning = Warning.create!(source: 'rubocop',
                      filename: warning['path'],
                      line_number: warning['line'],
                      description: warning['message'],
                      log_level: warning['level'],
                      commit_id: commit.id)
      puts warning.inspect
    end
  end
end
