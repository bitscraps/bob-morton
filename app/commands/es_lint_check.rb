class EsLintCheck < StatusCheck
  private

  def check_name
    'ESlint'
  end

  def check_command
    "pronto run --commit=develop --runner=eslint --commit=#{base_ref}"
  end

  def send_status_check?
    false
  end

  def parse_output_for_info(command_output)
    json_output = JSON.parse(command_output)
    json_output.length
  end

  def store_data(options)
    commit = Commit.find_or_create_by(sha: options[:sha], number: options[:number])

    JSON.parse(options[:rubocop_output]).each do |warning|
      Warning.create!(source: 'eslint',
                      filename: warning['path'],
                      line_number: warning['line'],
                      description: warning['message'],
                      log_level: warning['level'],
                      commit_id: commit.id)
    end
  end
end
