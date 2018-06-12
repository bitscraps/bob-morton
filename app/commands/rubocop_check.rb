class RubocopCheck < StatusCheck
  private

  def check_name
    'rubocop'
  end

  def check_command
    'pronto run --runner=rubocop formatters=json' #Lets add a really long comment to this line that goes on and on and on and on and on and on
  end

  def parse_output_for_info(command_output)
    output = JSON.parse(command_output)
    output.length
  end

  def store_data(options)
    commit = Commit.find_or_create_by(sha: options[:sha], number: options[:number])
    commit.merge_branch_rubocop_warnings = options[:merge_branch_rubocop_warnings]
    commit.this_branch_rubocop_warnings = options[:this_branch_rubocop_warnings]
    commit.rubocop_output = options[:rubocop_output]
    commit.save!

    JSON.parse(commit.rubocop_output).each do |warning|
      commit << Warning.create(source: 'rubocop',
                               filename: warning['path'],
                               line_number: warning['line'],
                               description: warning['message'],
                               log_level: warning['level'])
    end
  end
end
