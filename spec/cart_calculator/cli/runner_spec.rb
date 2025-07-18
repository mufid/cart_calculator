require 'spec_helper'

RSpec.describe CartCalculator::CLI::Runner do
  let(:io) { instance_double(CartCalculator::CLI::IO) }
  let(:runner) { described_class.new(io) }

  describe '#run' do
    context 'when user enters product codes and exits' do
      before do
        # Expect the welcome messages
        expect(io).to receive(:puts).with("Welcome to Cart Calculator!").ordered
        expect(io).to receive(:puts).with("Enter product codes separated by spaces (e.g., 'B01 B01 G01')").ordered
        expect(io).to receive(:puts).with("Type 'exit' to quit").ordered
        expect(io).to receive(:puts).with(no_args).ordered

        # First interaction: enter products
        expect(io).to receive(:print).with("> ").ordered
        expect(io).to receive(:gets).and_return("B01 G01\n").ordered
        
        # Expect order summary output
        expect(io).to receive(:puts).with("\nOrder Summary:").ordered
        expect(io).to receive(:puts).with("-" * 40).ordered
        expect(io).to receive(:puts).with("Blue Widget (B01) x1: $7.95").ordered
        expect(io).to receive(:puts).with("Green Widget (G01) x1: $24.95").ordered
        expect(io).to receive(:puts).with("-" * 40).ordered
        expect(io).to receive(:puts).with("Subtotal: $32.90").ordered
        expect(io).to receive(:puts).with("Delivery: $4.95").ordered
        expect(io).to receive(:puts).with("-" * 40).ordered
        expect(io).to receive(:puts).with("Grand Total: $37.85").ordered
        expect(io).to receive(:puts).with(no_args).ordered

        # Second interaction: exit
        expect(io).to receive(:print).with("> ").ordered
        expect(io).to receive(:gets).and_return("exit\n").ordered
        
        # Expect goodbye message
        expect(io).to receive(:puts).with("Thank you for using Cart Calculator!").ordered
      end

      it 'processes the order and displays the correct output' do
        runner.run
      end
    end

    context 'when user enters invalid product code' do
      before do
        # Expect the welcome messages
        expect(io).to receive(:puts).with("Welcome to Cart Calculator!").ordered
        expect(io).to receive(:puts).with("Enter product codes separated by spaces (e.g., 'B01 B01 G01')").ordered
        expect(io).to receive(:puts).with("Type 'exit' to quit").ordered
        expect(io).to receive(:puts).with(no_args).ordered

        # First interaction: enter invalid product
        expect(io).to receive(:print).with("> ").ordered
        expect(io).to receive(:gets).and_return("INVALID\n").ordered
        
        # Expect error message
        expect(io).to receive(:puts).with("Error: Product INVALID not found").ordered
        expect(io).to receive(:puts).with(no_args).ordered

        # Second interaction: exit
        expect(io).to receive(:print).with("> ").ordered
        expect(io).to receive(:gets).and_return("exit\n").ordered
        
        # Expect goodbye message
        expect(io).to receive(:puts).with("Thank you for using Cart Calculator!").ordered
      end

      it 'displays an error message' do
        runner.run
      end
    end

    context 'when user enters empty input' do
      before do
        # Expect the welcome messages
        expect(io).to receive(:puts).with("Welcome to Cart Calculator!").ordered
        expect(io).to receive(:puts).with("Enter product codes separated by spaces (e.g., 'B01 B01 G01')").ordered
        expect(io).to receive(:puts).with("Type 'exit' to quit").ordered
        expect(io).to receive(:puts).with(no_args).ordered

        # First interaction: enter empty line
        expect(io).to receive(:print).with("> ").ordered
        expect(io).to receive(:gets).and_return("\n").ordered
        
        # No output expected for empty input

        # Second interaction: exit
        expect(io).to receive(:print).with("> ").ordered
        expect(io).to receive(:gets).and_return("exit\n").ordered
        
        # Expect goodbye message
        expect(io).to receive(:puts).with("Thank you for using Cart Calculator!").ordered
      end

      it 'ignores empty input and continues' do
        runner.run
      end
    end

    context 'when user gets discount for red widgets' do
      before do
        # Expect the welcome messages
        expect(io).to receive(:puts).with("Welcome to Cart Calculator!").ordered
        expect(io).to receive(:puts).with("Enter product codes separated by spaces (e.g., 'B01 B01 G01')").ordered
        expect(io).to receive(:puts).with("Type 'exit' to quit").ordered
        expect(io).to receive(:puts).with(no_args).ordered

        # First interaction: enter two red widgets
        expect(io).to receive(:print).with("> ").ordered
        expect(io).to receive(:gets).and_return("R01 R01\n").ordered
        
        # Expect order summary output with discount
        expect(io).to receive(:puts).with("\nOrder Summary:").ordered
        expect(io).to receive(:puts).with("-" * 40).ordered
        expect(io).to receive(:puts).with("Red Widget (R01) x2: $65.90").ordered
        expect(io).to receive(:puts).with("-" * 40).ordered
        expect(io).to receive(:puts).with("Subtotal: $65.90").ordered
        expect(io).to receive(:puts).with("Discount: -$16.48").ordered
        expect(io).to receive(:puts).with("Delivery: $4.95").ordered
        expect(io).to receive(:puts).with("-" * 40).ordered
        expect(io).to receive(:puts).with("Grand Total: $54.37").ordered
        expect(io).to receive(:puts).with(no_args).ordered

        # Second interaction: exit
        expect(io).to receive(:print).with("> ").ordered
        expect(io).to receive(:gets).and_return("exit\n").ordered
        
        # Expect goodbye message
        expect(io).to receive(:puts).with("Thank you for using Cart Calculator!").ordered
      end

      it 'applies the red widget discount correctly' do
        runner.run
      end
    end
  end
end