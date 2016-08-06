require 'spec_helper'

describe 'NSQ role general specs' do
  %w(nsq_pubsub nsq_stat nsq_tail nsq_to_file nsq_to_http nsq_to_nsq to_nsq).each do |binary|
    describe file("/usr/local/bin/#{binary}") do
      it { should exist }
    end
  end
end
