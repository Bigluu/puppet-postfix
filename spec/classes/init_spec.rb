require 'spec_helper'

describe 'postfix' do
  describe 'class without any paramter' do
    it { is_expected.to compile.with_all_deps }
  end
end
