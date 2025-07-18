require 'bigdecimal'

module CartCalculator
  module Models
    # Provides a product catalogue with pre-defined products.
    # This class contains a DEFAULT constant with the standard product inventory.
    #
    # @example Using the default catalogue
    #   catalogue = CartCalculator::Models::Catalogue::DEFAULT
    #   product = catalogue['R01']
    #   product.name  # => "Red Widget"
    #   product.price # => BigDecimal("32.95")
    #
    # @example Available products in default catalogue
    #   catalogue = CartCalculator::Models::Catalogue::DEFAULT
    #   catalogue.keys # => ["R01", "G01", "B01"]
    #   
    #   # R01: Red Widget - $32.95
    #   # G01: Green Widget - $24.95
    #   # B01: Blue Widget - $7.95
    #
    # @example Creating a custom catalogue
    #   custom_catalogue = {
    #     'P01' => CartCalculator::Models::Product.new(
    #       code: 'P01',
    #       name: 'Purple Widget',
    #       price: '19.99'
    #     ),
    #     'Y01' => CartCalculator::Models::Product.new(
    #       code: 'Y01',
    #       name: 'Yellow Widget',
    #       price: '14.50'
    #     )
    #   }
    #   cart = CartCalculator::Models::Cart.new(
    #     catalogue: custom_catalogue,
    #     delivery_rules: delivery_rules,
    #     offers: {}
    #   )
    class Catalogue
      # Default product catalogue containing three widget types:
      # - R01: Red Widget ($32.95)
      # - G01: Green Widget ($24.95)
      # - B01: Blue Widget ($7.95)
      #
      # @return [Hash<String, Product>] frozen hash mapping product codes to Product instances
      #
      # @example Accessing products
      #   red_widget = CartCalculator::Models::Catalogue::DEFAULT['R01']
      #   red_widget.code  # => "R01"
      #   red_widget.name  # => "Red Widget"
      #   red_widget.price # => BigDecimal("32.95")
      DEFAULT = {
        'R01' => Product.new(code: 'R01', name: 'Red Widget', price: '32.95'),
        'G01' => Product.new(code: 'G01', name: 'Green Widget', price: '24.95'),
        'B01' => Product.new(code: 'B01', name: 'Blue Widget', price: '7.95')
      }.freeze
    end
  end
end