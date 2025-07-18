require 'bigdecimal'

module CartCalculator
  module Models
    # Represents a line item in a shopping cart, containing a product and its quantity.
    # Line items are created with a quantity of 1 and can be incremented as needed.
    #
    # @example Creating a line item
    #   product = CartCalculator::Models::Product.new(
    #     code: 'B01',
    #     name: 'Blue Widget',
    #     price: '7.95'
    #   )
    #   line_item = CartCalculator::Models::LineItem.new(product)
    #   line_item.quantity # => 1
    #   line_item.subtotal # => BigDecimal("7.95")
    #
    # @example Incrementing quantity
    #   line_item = CartCalculator::Models::LineItem.new(product)
    #   line_item.increment_quantity
    #   line_item.increment_quantity
    #   line_item.quantity # => 3
    #   line_item.subtotal # => BigDecimal("23.85")
    #
    # @example Calculating subtotal with multiple quantities
    #   product = CartCalculator::Models::Product.new(
    #     code: 'R01',
    #     name: 'Red Widget',
    #     price: '32.95'
    #   )
    #   line_item = CartCalculator::Models::LineItem.new(product)
    #   line_item.increment_quantity
    #   line_item.quantity # => 2
    #   line_item.subtotal # => BigDecimal("65.90")
    class LineItem
      # @return [Product] the product in this line item
      attr_reader :product
      
      # @return [Integer] the quantity of the product
      attr_reader :quantity

      # Creates a new LineItem with quantity initialized to 1
      #
      # @param product [Product] the product for this line item
      #
      # @example Create a line item
      #   product = CartCalculator::Models::Product.new(
      #     code: 'G01',
      #     name: 'Green Widget',
      #     price: '24.95'
      #   )
      #   line_item = CartCalculator::Models::LineItem.new(product)
      def initialize(product)
        @product = product
        @quantity = 1
      end

      # Increments the quantity by 1
      #
      # @return [Integer] the new quantity
      #
      # @example Increment quantity multiple times
      #   line_item.increment_quantity # => 2
      #   line_item.increment_quantity # => 3
      #   line_item.quantity # => 3
      def increment_quantity
        @quantity += 1
      end

      # Calculates the subtotal for this line item (price × quantity)
      #
      # @return [BigDecimal] the subtotal amount
      #
      # @example Calculate subtotal
      #   # Product with price $7.95
      #   line_item.quantity # => 1
      #   line_item.subtotal # => BigDecimal("7.95")
      #   
      #   line_item.increment_quantity
      #   line_item.quantity # => 2
      #   line_item.subtotal # => BigDecimal("15.90")
      def subtotal
        product.price * BigDecimal(quantity.to_s)
      end
    end
  end
end