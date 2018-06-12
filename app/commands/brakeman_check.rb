class BrakemanCheck < StatusCheck
  private

  def check_name
    'brakeman'
  end

  def check_command
    'pronto run --runner=rubocop formatters=json'
  end

  def parse_output_for_info(command_output)
    puts 'parsing_output'
    puts command_output
    json_output = JSON.parse(command_output)
    json_output.length
  end

  def store_data(options)
    commit = Commit.find_or_create_by(sha: options[:sha], number: options[:number])
    commit.merge_branch_brakeman_warnings = options[:merge_branch_rubocop_warnings]
    commit.this_branch_brakeman_warnings = options[:this_branch_rubocop_warnings]
    commit.brakeman_output = options[:rubocop_output]
    commit.save!

    JSON.parse(commit.rubocop_output).each do |warning|
      commit << Warning.create(source: 'brakeman', 
                               filename: warning['path'], 
                               line_number: warning['line'], 
                               description: warning['message'], 
                               log_level: warning['level'])
    end
  end
end
