require 'spec_helper'
require 'stringio'

RSpec.describe 'Cart Calculator Integration Tests' do
  def run_with_input(input)
    input_io = StringIO.new(input)
    output_io = StringIO.new
    
    io = CartCalculator::CLI::IO.new(input_io, output_io)
    runner = CartCalculator::CLI::Runner.new(io)
    runner.run
    
    output_io.string
  end

  # Find all example files
  examples_dir = File.join(File.dirname(__FILE__), '../../examples')
  example_files = Dir[File.join(examples_dir, '*-in.txt')].sort

  # Generate a test for each example
  example_files.each do |input_file|
    example_name = File.basename(input_file, '-in.txt')
    output_file = input_file.sub('-in.txt', '-out.txt')
    
    it "processes example #{example_name} correctly" do
      input = File.read(input_file)
      expected_output = File.read(output_file)
      
      actual_output = run_with_input(input)
      
      expect(actual_output).to eq(expected_output)
    end
  end

  context 'when no examples exist' do
    it 'finds and runs at least one example' do
      expect(example_files).not_to be_empty, 
        "No example files found in #{examples_dir}"
    end
  end
end