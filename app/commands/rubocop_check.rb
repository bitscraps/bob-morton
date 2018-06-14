class RubocopCheck < StatusCheck
  private

  def check_name
    'rubocop'
  end

  def check_command
    'pronto run --runner=rubocop --formatters=json --commit=develop' #Lets add a really long comment to this line that goes on and on and on and on and on and on
  end

  def send_status_check?
    true
  end

  def parse_output_for_info(command_output)
    output = JSON.parse(command_output)
    output.length
  end

  def store_data(options)
    puts "store data"
    commit = Commit.find_or_create_by(sha: options[:sha], number: options[:number])

    puts commit.inspect
    puts commit.save!


    puts commit.inspect

    JSON.parse(options[:rubocop_output]).each do |warning|
      puts "create warning"
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
