class CompleteTest < ActiveCommand::Base
  required :required_parameter, type: :array
  optional :optional_parameter, type: :integer

  before do
    parameter << 1
  end

  before do
    parameter << 2
  end

  def call
    parameter << 'call'
  end

  after do
    parameter << 'after 1'
  end

  after do
    parameter << 'after 2'
  end
end
