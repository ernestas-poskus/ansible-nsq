require 'spec_helper'

describe 'NSQ nsqd service' do
  describe service('nsqd') do
    it { should be_enabled }
  end

  describe service('nsqd') do
    it { should be_running }
  end
end
