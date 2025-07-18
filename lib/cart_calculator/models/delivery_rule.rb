require 'bigdecimal'

module CartCalculator
  module Models
    # Defines delivery charge rules based on order amount ranges.
    # This class provides a DEFAULT constant with standard delivery pricing tiers.
    #
    # @example Using default delivery rules
    #   rules = CartCalculator::Models::DeliveryRule::DEFAULT
    #   # rules = [
    #   #   { min_amount: BigDecimal('90'), max_amount: nil, charge: BigDecimal('0') },
    #   #   { min_amount: BigDecimal('50'), max_amount: BigDecimal('90'), charge: BigDecimal('2.95') },
    #   #   { min_amount: BigDecimal('0'), max_amount: BigDecimal('50'), charge: BigDecimal('4.95') }
    #   # ]
    #
    # @example Delivery charges by order total
    #   # Order under $50: $4.95 delivery
    #   # Order $50-$90: $2.95 delivery  
    #   # Order $90+: Free delivery
    #
    # @example Creating custom delivery rules
    #   custom_rules = [
    #     { min_amount: BigDecimal('100'), max_amount: nil, charge: BigDecimal('0') },
    #     { min_amount: BigDecimal('25'), max_amount: BigDecimal('100'), charge: BigDecimal('5.00') },
    #     { min_amount: BigDecimal('0'), max_amount: BigDecimal('25'), charge: BigDecimal('10.00') }
    #   ]
    #   cart = CartCalculator::Models::Cart.new(
    #     catalogue: catalogue,
    #     delivery_rules: custom_rules,
    #     offers: {}
    #   )
    class DeliveryRule
      # Default delivery charge rules with three tiers:
      # - Orders $90 or more: Free delivery
      # - Orders $50 to $90: $2.95 delivery charge
      # - Orders under $50: $4.95 delivery charge
      #
      # @return [Array<Hash>] frozen array of delivery rule hashes
      #
      # @example Structure of a delivery rule
      #   {
      #     min_amount: BigDecimal('50'),  # Minimum order amount (inclusive)
      #     max_amount: BigDecimal('90'),  # Maximum order amount (exclusive), nil for no upper limit
      #     charge: BigDecimal('2.95')     # Delivery charge for this range
      #   }
      DEFAULT = [
        { min_amount: BigDecimal('90'), max_amount: nil, charge: BigDecimal('0') },
        { min_amount: BigDecimal('50'), max_amount: BigDecimal('90'), charge: BigDecimal('2.95') },
        { min_amount: BigDecimal('0'), max_amount: BigDecimal('50'), charge: BigDecimal('4.95') }
      ].freeze
    end
  end
end