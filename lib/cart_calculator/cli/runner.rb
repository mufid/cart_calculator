require "cart_calculator"

module CartCalculator
  module CLI
    # The main CLI runner for the Cart Calculator application.
    # Provides an interactive REPL (Read-Eval-Print Loop) for processing cart orders.
    #
    # @example Running the CLI
    #   io = CartCalculator::CLI::IO.new
    #   runner = CartCalculator::CLI::Runner.new(io)
    #   runner.run
    #
    # @example Using with custom IO for testing
    #   input = StringIO.new("B01 G01\nexit\n")
    #   output = StringIO.new
    #   io = CartCalculator::CLI::IO.new(input, output)
    #   runner = CartCalculator::CLI::Runner.new(io)
    #   runner.run
    #   output.string # => Contains the formatted output
    #
    # @note Architecture
    #   The Runner class is designed with the following architectural principles:
    #
    #   1. Dependency Injection for IO: The runner accepts an IO object instead of using
    #      puts/gets directly. This separation allows for:
    #      - Easy unit testing with mock IO objects
    #      - Flexibility to redirect input/output (e.g., files, network streams)
    #      - Clear separation between business logic and IO concerns
    #
    #   2. Separation of Concerns: The IO logic is extracted into a separate IO class because:
    #      - It encapsulates all input/output operations in one place
    #      - Makes the runner focused on orchestration rather than IO details
    #      - Allows different IO implementations (console, file, network) without changing the runner
    #      - Follows the Single Responsibility Principle
    #
    #   3. REPL Pattern: The runner implements a Read-Eval-Print Loop for:
    #      - Interactive user experience
    #      - Continuous operation without restarting
    #      - Clear session boundaries with welcome/goodbye messages
    #
    #   4. Error Handling: Gracefully handles errors at the appropriate level:
    #      - Invalid product codes show error messages but continue the session
    #      - Empty input is silently ignored for better UX
    class Runner
      # Creates a new Runner instance
      #
      # @param io [CartCalculator::CLI::IO] the IO object for input/output operations
      def initialize(io)
        @io = io
      end

      # Runs the interactive cart calculator REPL
      #
      # @example Interactive session
      #   > B01 G01
      #   
      #   Order Summary:
      #   ----------------------------------------
      #   Blue Widget (B01) x1: $7.95
      #   Green Widget (G01) x1: $24.95
      #   ----------------------------------------
      #   Subtotal: $32.90
      #   Delivery: $4.95
      #   ----------------------------------------
      #   Grand Total: $37.85
      #   
      #   > exit
      #   Thank you for using Cart Calculator!
      def run
        @io.puts "Welcome to Cart Calculator!"
        @io.puts "Enter product codes separated by spaces (e.g., 'B01 B01 G01')"
        @io.puts "Type 'exit' to quit"
        @io.puts

        loop do
          @io.print "> "
          input = @io.gets.chomp
          
          break if input.downcase == "exit"
          
          next if input.strip.empty?
          
          process_order(input)
          @io.puts
        end
        
        @io.puts "Thank you for using Cart Calculator!"
      end

      private

      # Processes a single order from user input
      #
      # @param input [String] space-separated product codes
      def process_order(input)
        product_codes = input.strip.split(/\s+/)
        cart = CartCalculator::Models::Cart.new(
          catalogue: CartCalculator::Models::Catalogue::DEFAULT,
          delivery_rules: CartCalculator::Models::DeliveryRule::DEFAULT,
          offers: { red_widget_half_price: true }
        )
        
        begin
          product_codes.each { |code| cart.add(code) }
          display_order_summary(cart)
        rescue CartCalculator::Error => e
          @io.puts "Error: #{e.message}"
        end
      end

      # Displays a formatted order summary for the cart
      #
      # @param cart [CartCalculator::Models::Cart] the cart to summarize
      def display_order_summary(cart)
        @io.puts "\nOrder Summary:"
        @io.puts "-" * 40
        
        # Display line items with subtotals
        cart.items.values.each do |line_item|
          product = line_item.product
          quantity = line_item.quantity
          subtotal = line_item.subtotal
          
          @io.puts "#{product.name} (#{product.code}) x#{quantity}: $#{'%.2f' % subtotal}"
        end
        
        @io.puts "-" * 40
        
        # Calculate totals
        subtotal = cart.calculate_subtotal
        discount = cart.calculate_discount
        delivery = cart.delivery_charge
        grand_total = cart.total
        
        # Display summary
        @io.puts "Subtotal: $#{'%.2f' % subtotal}"
        @io.puts "Discount: -$#{'%.2f' % discount}" if discount > 0
        @io.puts "Delivery: $#{'%.2f' % delivery}"
        @io.puts "-" * 40
        @io.puts "Grand Total: $#{'%.2f' % grand_total}"
      end
    end
  end
end