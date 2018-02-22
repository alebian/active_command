class BeforeTest < ActiveCommand::Base
  required :parameter, type: :array

  before do
    parameter << 'before 1'
  end

  before do
    parameter << 'before 2'
  end

  def call
    parameter << 'call'
  end
end
