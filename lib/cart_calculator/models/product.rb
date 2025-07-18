require 'bigdecimal'

module CartCalculator
  module Models
    class Product
      attr_reader :code, :name, :price

      def initialize(code:, name:, price:)
        raise ArgumentError, 'Price must be a string' unless price.is_a?(String)
        @code = code
        @name = name
        @price = BigDecimal(price)
      end
    end
  end
end
