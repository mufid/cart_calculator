require "cart_calculator"

module CartCalculator
  module CLI
    class Runner
      def initialize
      end

      def run
        puts "Welcome to Cart Calculator!"
        puts "Enter product codes separated by spaces (e.g., 'B01 B01 G01')"
        puts "Type 'exit' to quit"
        puts

        loop do
          print "> "
          input = gets.chomp
          
          break if input.downcase == "exit"
          
          next if input.strip.empty?
          
          process_order(input)
          puts
        end
        
        puts "Thank you for using Cart Calculator!"
      end

      private

      def process_order(input)
        product_codes = input.strip.split(/\s+/)
        cart = CartCalculator::Cart.new(
          catalogue: CartCalculator::Catalogue::DEFAULT,
          delivery_rules: CartCalculator::DeliveryRule::DEFAULT,
          offers: { red_widget_half_price: true }
        )
        
        begin
          product_codes.each { |code| cart.add(code) }
          display_order_summary(cart)
        rescue CartCalculator::Error => e
          puts "Error: #{e.message}"
        end
      end

      def display_order_summary(cart)
        puts "\nOrder Summary:"
        puts "-" * 40
        
        # Display line items with subtotals
        cart.items.values.each do |line_item|
          product = line_item.product
          quantity = line_item.quantity
          subtotal = line_item.subtotal
          
          puts "#{product.name} (#{product.code}) x#{quantity}: $#{'%.2f' % subtotal}"
        end
        
        puts "-" * 40
        
        # Calculate totals
        subtotal = cart.calculate_subtotal
        discount = cart.calculate_discount
        delivery = cart.delivery_charge
        grand_total = cart.total
        
        # Display summary
        puts "Subtotal: $#{'%.2f' % subtotal}"
        puts "Discount: -$#{'%.2f' % discount}" if discount > 0
        puts "Delivery: $#{'%.2f' % delivery}"
        puts "-" * 40
        puts "Grand Total: $#{'%.2f' % grand_total}"
      end
    end
  end
end