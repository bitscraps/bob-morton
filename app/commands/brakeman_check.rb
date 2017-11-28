class BrakemanCheck < StatusCheck
  private

  def check_name
    'brakeman'
  end

  def check_command
    'brakeman -f'
  end

  def parse_output_for_info(command_output)
    puts 'parsing_output'
    puts command_output
    json_output = JSON.parse(command_output)
    json_output['scan_info']['security_warnings']
  end

  def store_data(options)
  end
end
