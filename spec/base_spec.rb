require 'spec_helper'

describe ActiveCommand::Base do
  describe '.call' do
    let(:example_class) {}
  end

  describe '#call' do
    let(:example_class) { BeforeTest }

    it 'returns an instance of the class' do
      expect(example_class.call(parameter: []).is_a?(example_class)).to be_truthy
    end
  end

  describe '.required' do
    let(:example_class) {}
  end

  describe '.optional' do
    let(:example_class) {}
  end

  describe '.before' do
    let(:example_class) { BeforeTest }
    let(:test_array)    { [] }
    let(:hooks_size)    { 2 }

    it 'adds the blocks to the execute list' do
      expect(example_class.class_variable_get(:@@before_hooks).size).to eq(hooks_size)
    end

    context 'when executing blocks' do
      before do
        example_class.call(parameter: test_array)
      end

      it 'adds the elements' do
        expect(test_array.size).to eq(hooks_size + 1)
      end

      it 'adds the elements in the correct order' do
        expect(test_array).to match(['before 1', 'before 2', 'call'])
      end
    end
  end

  describe '.after' do
    let(:example_class) { AfterTest }
    let(:test_array)    { [] }
    let(:hooks_size)    { 2 }

    it 'adds the blocks to the execute list' do
      expect(example_class.class_variable_get(:@@after_hooks).size).to eq(hooks_size)
    end

    context 'when executing blocks' do
      before do
        example_class.call(parameter: test_array)
      end

      it 'adds the elements' do
        expect(test_array.size).to eq(hooks_size + 1)
      end

      it 'adds the elements in the correct order' do
        expect(test_array).to match(['call', 'after 1', 'after 2'])
      end
    end
  end
end
