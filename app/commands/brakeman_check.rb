class BrakemanCheck < StatusCheck
  private

  def check_name
    'brakeman'
  end

  def check_command
    'bundle exec brakeman -f'
  end

  def parse_output_for_info(output)
    puts output
    json_output = JSON.parse(output)
    json_output['scan_info']['security_warnings']
  end

  def store_data(options)
  end
end
