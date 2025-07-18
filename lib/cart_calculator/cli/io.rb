module CartCalculator
  module CLI
    # Wrapper class for input/output operations, providing an abstraction layer
    # over standard IO operations. This enables easy testing and flexible IO redirection.
    #
    # @example Using with standard input/output
    #   io = CartCalculator::CLI::IO.new
    #   io.puts "Hello, World!"
    #   io.print "Enter name: "
    #   name = io.gets.chomp
    #
    # @example Using with custom IO streams for testing
    #   input = StringIO.new("test input\n")
    #   output = StringIO.new
    #   io = CartCalculator::CLI::IO.new(input, output)
    #   
    #   io.puts "Processing..."
    #   user_input = io.gets
    #   
    #   output.string # => "Processing...\n"
    #   user_input    # => "test input\n"
    #
    # @example Mocking IO in tests
    #   io = instance_double(CartCalculator::CLI::IO)
    #   expect(io).to receive(:puts).with("Welcome!")
    #   expect(io).to receive(:gets).and_return("B01 G01\n")
    #   
    #   runner = CartCalculator::CLI::Runner.new(io)
    #   # Test runner behavior with mocked IO
    class IO
      # Creates a new IO wrapper instance
      #
      # @param input [IO] the input stream (defaults to $stdin)
      # @param output [IO] the output stream (defaults to $stdout)
      #
      # @example Default initialization
      #   io = CartCalculator::CLI::IO.new
      #
      # @example Custom streams
      #   io = CartCalculator::CLI::IO.new(File.open('input.txt'), File.open('output.txt', 'w'))
      def initialize(input = $stdin, output = $stdout)
        @input = input
        @output = output
      end

      # Writes a line to the output stream
      #
      # @param message [String] the message to write (defaults to empty string)
      # @return [nil]
      #
      # @example Writing messages
      #   io.puts "Hello"
      #   io.puts           # Writes a blank line
      #   io.puts "World"
      def puts(message = "")
        @output.puts(message)
      end

      # Writes text to the output stream without a newline
      #
      # @param message [String] the message to write
      # @return [nil]
      #
      # @example Prompting for input
      #   io.print "Enter your choice: "
      #   choice = io.gets.chomp
      def print(message)
        @output.print(message)
      end

      # Reads a line from the input stream
      #
      # @return [String, nil] the line read from input, or nil if EOF
      #
      # @example Reading user input
      #   io.print "> "
      #   input = io.gets.chomp
      #   
      #   # Handle EOF gracefully
      #   if line = io.gets
      #     process(line.chomp)
      #   end
      def gets
        @input.gets
      end
    end
  end
end