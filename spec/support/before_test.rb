class BeforeTest < ActiveCommand::Base
  required :parameter, type: :array

  before do
    add_value_to_param('before 1')
  end

  before do
    add_value_to_param('before 2')
  end

  def call
    add_value_to_param('call')
  end

  private

  def add_value_to_param(value)
    parameter << value
  end
end
