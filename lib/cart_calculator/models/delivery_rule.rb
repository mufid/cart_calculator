require 'bigdecimal'

module CartCalculator
  class DeliveryRule
    DEFAULT = [
      { min_amount: BigDecimal('90'), max_amount: nil, charge: BigDecimal('0') },
      { min_amount: BigDecimal('50'), max_amount: BigDecimal('90'), charge: BigDecimal('2.95') },
      { min_amount: BigDecimal('0'), max_amount: BigDecimal('50'), charge: BigDecimal('4.95') }
    ].freeze
  end
end