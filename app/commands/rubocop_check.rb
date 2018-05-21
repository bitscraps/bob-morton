class RubocopCheck < StatusCheck
  private

  def check_name
    'rubocop'
  end

  def check_command
    'rubocop'
  end

  def parse_output_for_info(command_output)
    /, (.*?) offenses detected/.match(command_output.split("\n").last)[1]
  end

  def store_data(options)
    commit = Commit.find_or_create_by(sha: options[:sha], number: options[:number])
    commit.merge_branch_rubocop_warnings = options[:merge_branch_rubocop_warnings]
    commit.this_branch_rubocop_warnings = options[:this_branch_rubocop_warnings]
    commit.rubocop_output = options[:rubocop_output]
    commit.save!
  end
end
