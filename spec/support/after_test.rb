class AfterTest < ActiveCommand::Base
  required :parameter, type: Array

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
