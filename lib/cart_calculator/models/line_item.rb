require 'bigdecimal'

module CartCalculator
  module Models
    class LineItem
      attr_reader :product, :quantity

      def initialize(product)
        @product = product
        @quantity = 1
      end

      def increment_quantity
        @quantity += 1
      end

      def subtotal
        product.price * BigDecimal(quantity.to_s)
      end
    end
  end
end
