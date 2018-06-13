class RailsBestPracticesCheck < StatusCheck
  private

  def check_name
    'rails_best_practices'
  end

  def check_command
    'pronto run --commit=develop --runner=rails_best_practices --formatters=json'
  end

  def parse_output_for_info(command_output)
    json_output = JSON.parse(command_output)
    json_output.length
  end

  def store_data(options)
    commit = Commit.find_or_create_by(sha: options[:sha], number: options[:number])
    commit.save!

    JSON.parse(commit.brakeman_output).each do |warning|
      commit.warnings << Warning.new(source: 'rails_best_practices',
                               filename: warning['path'],
                               line_number: warning['line'],
                               description: warning['message'],
                               log_level: warning['level'])
    end
  end
end
