require 'bigdecimal'

module CartCalculator
  module Models
    # Represents a product that can be added to a cart.
    # Products have a code, name, and price stored as BigDecimal for precise calculations.
    #
    # @example Creating a product
    #   product = CartCalculator::Models::Product.new(
    #     code: 'R01',
    #     name: 'Red Widget',
    #     price: '32.95'
    #   )
    #   product.code  # => "R01"
    #   product.name  # => "Red Widget"
    #   product.price # => BigDecimal("32.95")
    #
    # @example Price must be a string for BigDecimal precision
    #   # Good - preserves decimal precision
    #   product = CartCalculator::Models::Product.new(
    #     code: 'B01',
    #     name: 'Blue Widget',
    #     price: '7.95'
    #   )
    #   
    #   # Bad - raises ArgumentError
    #   product = CartCalculator::Models::Product.new(
    #     code: 'B01',
    #     name: 'Blue Widget',
    #     price: 7.95
    #   )
    class Product
      # @return [String] the unique product code
      attr_reader :code
      
      # @return [String] the human-readable product name
      attr_reader :name
      
      # @return [BigDecimal] the product price
      attr_reader :price

      # Creates a new Product instance
      #
      # @param code [String] the unique product code
      # @param name [String] the human-readable product name
      # @param price [String] the product price as a string (for BigDecimal precision)
      # @raise [ArgumentError] if price is not a string
      #
      # @example Create a product
      #   product = CartCalculator::Models::Product.new(
      #     code: 'G01',
      #     name: 'Green Widget',
      #     price: '24.95'
      #   )
      def initialize(code:, name:, price:)
        raise ArgumentError, 'Price must be a string' unless price.is_a?(String)
        @code = code
        @name = name
        @price = BigDecimal(price)
      end
    end
  end
end