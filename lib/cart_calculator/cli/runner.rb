require "cart_calculator"

module CartCalculator
  module CLI
    class Runner
      def initialize(io)
        @io = io
      end

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