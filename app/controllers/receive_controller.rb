class ReceiveController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def receive
    payload = JSON.parse(params[:payload])
    puts payload

    `git clone #{payload["repository"]["html_url"]} /tmp/201f8120bc5c67cf5205d4855b8755c6fc465423`
    warnings = `cd /tmp/201f8120bc5c67cf5205d4855b8755c6fc465423 && git checkout 201f8120bc5c67cf5205d4855b8755c6fc465423 && rubocop --format simple | grep "offenses detected"`
    `rm -rf /tmp/201f8120bc5c67cf5205d4855b8755c6fc465423`
    render text: warnings
  end
end
