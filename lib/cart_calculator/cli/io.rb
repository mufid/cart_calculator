module CartCalculator
  module CLI
    class IO
      def initialize(input = $stdin, output = $stdout)
        @input = input
        @output = output
      end

      def puts(message = "")
        @output.puts(message)
      end

      def print(message)
        @output.print(message)
      end

      def gets
        @input.gets
      end
    end
  end
end