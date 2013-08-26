require 'spec_helper'
describe ::Zip do
  subject { ::Zip }

  it { should respond_to(:reset!, :setup) }

end