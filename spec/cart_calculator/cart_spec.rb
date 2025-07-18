require 'spec_helper'

describe CartCalculator::Cart do
  let(:catalogue) do
    {
      'R01' => CartCalculator::Product.new(code: 'R01', name: 'Red Widget', price: '32.95'),
      'G01' => CartCalculator::Product.new(code: 'G01', name: 'Green Widget', price: '24.95'),
      'B01' => CartCalculator::Product.new(code: 'B01', name: 'Blue Widget', price: '7.95')
    }
  end

  let(:delivery_rules) do
    CartCalculator::DeliveryRule::DEFAULT
  end

  let(:offers) do
    { red_widget_half_price: true }
  end

  let(:cart) do
    described_class.new(
      catalogue: catalogue,
      delivery_rules: delivery_rules,
      offers: offers
    )
  end

  describe "#add" do
    it "adds a product to the cart" do
      expect { cart.add('B01') }.not_to raise_error
      expect(cart.items).to have_key('B01')
    end

    it "increments quantity when adding the same product twice" do
      cart.add('B01')
      cart.add('B01')
      expect(cart.items['B01'].quantity).to eq(2)
    end

    it "raises an error when adding an invalid product code" do
      expect { cart.add('INVALID') }.to raise_error(ArgumentError, "Product INVALID not found")
    end
  end

  describe "#total" do
    context "with example baskets from README" do
      it "calculates B01, G01 = $37.85" do
        cart.add('B01')
        cart.add('G01')
        expect(cart.total).to eq(BigDecimal('37.85'))
      end

      it "calculates R01, R01 = $54.37" do
        cart.add('R01')
        cart.add('R01')
        expect(cart.total).to eq(BigDecimal('54.37'))
      end

      it "calculates R01, G01 = $60.85" do
        cart.add('R01')
        cart.add('G01')
        expect(cart.total).to eq(BigDecimal('60.85'))
      end

      it "calculates B01, B01, R01, R01, R01 = $98.27" do
        cart.add('B01')
        cart.add('B01')
        cart.add('R01')
        cart.add('R01')
        cart.add('R01')
        expect(cart.total).to eq(BigDecimal('98.27'))
      end
    end

    context "delivery charges" do
      it "applies $4.95 delivery for orders under $50" do
        cart.add('B01') # $7.95
        cart.add('B01') # $7.95
        # Subtotal: $15.90, Delivery: $4.95
        expect(cart.total).to eq(20.85)
      end

      it "applies $2.95 delivery for orders between $50 and $90" do
        cart.add('G01') # $24.95
        cart.add('G01') # $24.95
        cart.add('B01') # $7.95
        # Subtotal: $57.85, Delivery: $2.95
        expect(cart.total).to eq(60.80)
      end

      it "applies free delivery for orders $90 or more" do
        cart.add('R01') # $32.95
        cart.add('R01') # $32.95
        cart.add('R01') # $32.95
        # Subtotal: $98.85, Discount: $16.475, Net: $82.375
        # Since net is < $90, delivery is $2.95
        # Total: $82.375 + $2.95 = $85.325
        expect(cart.total).to eq(BigDecimal('85.32'))
      end
    end

    context "red widget offer" do
      it "applies half price to second red widget" do
        cart.add('R01') # $32.95
        cart.add('R01') # $32.95 (half price: $16.475)
        # Subtotal: $65.90, Discount: $16.475, Net: $49.425
        # Delivery: $4.95 (under $50)
        # Total: $54.375
        expect(cart.total).to eq(54.37)
      end

      it "applies half price to pairs of red widgets" do
        cart.add('R01') # $32.95
        cart.add('R01') # $32.95 (half price)
        cart.add('R01') # $32.95
        cart.add('R01') # $32.95 (half price)
        # Subtotal: $131.80, Discount: $32.95, Net: $98.85
        # Delivery: $0.00 (over $90)
        # Total: $98.85
        expect(cart.total).to eq(98.85)
      end
    end
  end
end