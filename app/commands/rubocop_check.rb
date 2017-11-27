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
    commits = Commit.new(sha: options[:merge_sha],
                         merge_branch_rubocop_warnings: options[initial_warnings],
                         this_branch_rubocop_warnings: options[current_warnings],
                         rubocop_output: options[current_warnings_output],
                         number: options[number])
    commits.save!
  end
end
