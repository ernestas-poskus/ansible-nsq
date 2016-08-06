require 'spec_helper'

describe 'NSQ nsqlookupd service' do
  describe service('nsqlookupd') do
    it { should be_enabled }
  end

  describe service('nsqlookupd') do
    it { should be_running }
  end
end
