class RubocopCheck < StatusCheck
  private

  def check_name
    'rubocop'
  end

  def check_command
    'rubocop'
  end

  def parse_output_for_info(command_output)
    puts command_output
    /, (.*?) offenses detected/.match(command_output.split("\n").last)[1]
  end

  def store_data(options)
    commits = Commit.new(sha: options[:sha],
                         merge_branch_rubocop_warnings: options[:merge_branch_rubocop_warnings],
                         this_branch_rubocop_warnings: options[:this_branch_rubocop_warnings],
                         rubocop_output: options[:rubocop_output],
                         number: options[:number])
    commits.save!
  end
end
