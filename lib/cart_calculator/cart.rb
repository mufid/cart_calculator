require 'bigdecimal'

module CartCalculator
  class Cart
    attr_reader :catalogue, :delivery_rules, :offers, :items

    def initialize(catalogue:, delivery_rules:, offers:)
      @catalogue = catalogue
      @delivery_rules = delivery_rules
      @offers = offers
      @items = {}
    end

    def add(product_code)
      product = catalogue[product_code]
      raise ArgumentError, "Product #{product_code} not found" unless product

      if items[product_code]
        items[product_code].increment_quantity
      else
        items[product_code] = LineItem.new(product)
      end
    end

    def total
      subtotal = calculate_subtotal
      discount = calculate_discount
      delivery = calculate_delivery_charge(subtotal - discount)
      
      round_cent(subtotal - discount + delivery)
    end

    private

    def calculate_subtotal
      items.values.sum { |item| item.subtotal }
    end

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

    def calculate_delivery_charge(order_total)
      delivery_rules.each do |rule|
        if order_total >= rule[:min_amount] && (rule[:max_amount].nil? || order_total < rule[:max_amount])
          return rule[:charge]
        end
      end
      
      BigDecimal('0')
    end

    def round_cent(amount)
      BigDecimal((amount* 100).to_i) / 100
    end
  end
end
