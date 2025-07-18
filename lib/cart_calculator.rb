require "cart_calculator/version"
require "cart_calculator/models/product"
require "cart_calculator/models/line_item"
require "cart_calculator/models/delivery_rule"
require "cart_calculator/models/catalogue"
require "cart_calculator/models/cart"
require "cart_calculator/cli/io"
require "cart_calculator/cli/runner"

module CartCalculator
  class Error < StandardError; end
  
  # Convenience aliases for backward compatibility
  module Models
    # Models are already defined in their respective files
  end
end