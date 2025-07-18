require 'bigdecimal'

module CartCalculator
  module Models
    # Represents a shopping cart that can hold products, calculate totals, apply discounts, and determine delivery charges.
    #
    # @example Creating a cart and adding products
    #   cart = CartCalculator::Models::Cart.new(
    #     catalogue: CartCalculator::Models::Catalogue::DEFAULT,
    #     delivery_rules: CartCalculator::Models::DeliveryRule::DEFAULT,
    #     offers: { red_widget_half_price: true }
    #   )
    #   cart.add('B01')
    #   cart.add('G01')
    #   cart.total # => BigDecimal("37.85")
    #
    # @example Cart with discount (buy one red widget, get second half price)
    #   cart = CartCalculator::Models::Cart.new(
    #     catalogue: CartCalculator::Models::Catalogue::DEFAULT,
    #     delivery_rules: CartCalculator::Models::DeliveryRule::DEFAULT,
    #     offers: { red_widget_half_price: true }
    #   )
    #   cart.add('R01')
    #   cart.add('R01')
    #   cart.total # => BigDecimal("54.37")
    #
    # @note Architecture
    #   The Cart class is designed with several architectural principles in mind:
    #   
    #   1. Dependency Injection: The cart accepts its dependencies (catalogue, delivery rules, offers)
    #      through constructor injection, making it flexible and testable.
    #   
    #   2. Separation of Concerns: The cart delegates product lookup to the catalogue and uses
    #      configurable delivery rules, keeping the cart focused on its core responsibility.
    #   
    #   3. Models Namespace: The cart is placed in the Models namespace to clearly indicate it's
    #      a domain model, separate from infrastructure concerns like CLI or persistence.
    #   
    #   4. Configuration through Constants: DEFAULT constants in Catalogue and DeliveryRule provide
    #      sensible defaults while allowing custom configurations, following the convention over
    #      configuration principle.
    #   
    #   5. Immutable Configuration: The use of frozen DEFAULT constants ensures configuration
    #      integrity throughout the application lifecycle.
    class Cart
      # @return [Hash<String, Product>] the product catalogue
      attr_reader :catalogue
      
      # @return [Array<Hash>] the delivery charge rules
      attr_reader :delivery_rules
      
      # @return [Hash] the available offers
      attr_reader :offers
      
      # @return [Hash<String, LineItem>] the items in the cart
      attr_reader :items

      # Creates a new cart with the specified configuration
      #
      # @param catalogue [Hash<String, Product>] the product catalogue
      # @param delivery_rules [Array<Hash>] the delivery charge rules
      # @param offers [Hash] the available offers
      def initialize(catalogue:, delivery_rules:, offers:)
        @catalogue = catalogue
        @delivery_rules = delivery_rules
        @offers = offers
        @items = {}
      end

      # Adds a product to the cart by its code
      #
      # @param product_code [String] the code of the product to add
      # @raise [CartCalculator::Error] if the product code is not found in the catalogue
      #
      # @example Adding products to cart
      #   cart.add('B01')
      #   cart.add('B01') # Increments quantity of existing item
      def add(product_code)
        product = catalogue[product_code]
        raise CartCalculator::Error, "Product #{product_code} not found" unless product

        if items[product_code]
          items[product_code].increment_quantity
        else
          items[product_code] = LineItem.new(product)
        end
      end

      # Calculates the total price including discounts and delivery
      #
      # @return [BigDecimal] the total price
      #
      # @example Calculate total for a cart
      #   cart.add('B01')
      #   cart.add('G01')
      #   cart.total # => BigDecimal("37.85")
      def total
        subtotal = calculate_subtotal
        discount = calculate_discount
        delivery = calculate_delivery_charge(subtotal - discount)
        
        round_cent(subtotal - discount + delivery)
      end

      # Calculates the subtotal of all items in the cart
      #
      # @return [BigDecimal] the subtotal before discounts and delivery
      #
      # @example Calculate subtotal
      #   cart.add('B01')
      #   cart.add('G01')
      #   cart.calculate_subtotal # => BigDecimal("32.90")
      def calculate_subtotal
        items.values.sum { |item| item.subtotal }
      end

      # Calculates the discount amount based on active offers
      #
      # @return [BigDecimal] the discount amount
      #
      # @example Calculate discount for red widgets
      #   cart.add('R01')
      #   cart.add('R01')
      #   cart.calculate_discount # => BigDecimal("16.475")
      def calculate_discount
        discount = BigDecimal('0')
        
        # Apply "buy one red widget, get the second half price" offer
        if offers[:red_widget_half_price] && items['R01']
          red_widget_quantity = items['R01'].quantity
          red_widget_price = items['R01'].product.price
          
          # For every 2 red widgets, the second one is half price
          discount_pairs = red_widget_quantity / 2
          discount += discount_pairs * (red_widget_price / BigDecimal('2'))
        end
        
        discount
      end

      # Calculates the delivery charge based on the order total after discount
      #
      # @return [BigDecimal] the delivery charge
      #
      # @example Calculate delivery charge
      #   cart.add('B01')
      #   cart.delivery_charge # => BigDecimal("4.95")
      def delivery_charge
        subtotal = calculate_subtotal
        discount = calculate_discount
        calculate_delivery_charge(subtotal - discount)
      end

      private

      # Calculates delivery charge based on order total and rules
      #
      # @param order_total [BigDecimal] the order total after discounts
      # @return [BigDecimal] the delivery charge
      def calculate_delivery_charge(order_total)
        delivery_rules.each do |rule|
          if order_total >= rule[:min_amount] && (rule[:max_amount].nil? || order_total < rule[:max_amount])
            return rule[:charge]
          end
        end
        
        BigDecimal('0')
      end

      # Rounds an amount to the nearest cent
      #
      # @param amount [BigDecimal] the amount to round
      # @return [BigDecimal] the rounded amount
      def round_cent(amount)
        BigDecimal((amount* 100).to_i) / 100
      end
    end
  end
end