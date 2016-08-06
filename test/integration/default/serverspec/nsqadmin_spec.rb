require 'spec_helper'

describe 'NSQ nsqadmin service' do
  describe service('nsqadmin') do
    it { should be_enabled }
  end

  describe service('nsqadmin') do
    it { should be_running }
  end
end
