RSpec.describe CartCalculator::Models::LineItem do
  let(:product) { CartCalculator::Models::Product.new(code: 'B01', name: 'Blue Widget', price: '7.95') }
  subject(:line_item) { described_class.new(product) }

  describe "#initialize" do
    it "sets the product" do
      expect(line_item.product).to eq(product)
    end

    it "initializes quantity to 1" do
      expect(line_item.quantity).to eq(1)
    end
  end

  describe "#increment_quantity" do
    it "increases the quantity by 1" do
      expect { line_item.increment_quantity }.to change { line_item.quantity }.from(1).to(2)
    end

    it "can be called multiple times" do
      3.times { line_item.increment_quantity }
      expect(line_item.quantity).to eq(4)
    end
  end

  describe "#subtotal" do
    it "calculates product price times quantity" do
      expect(line_item.subtotal).to eq(BigDecimal('7.95'))
    end

    it "updates when quantity changes" do
      line_item.increment_quantity
      expect(line_item.subtotal).to eq(BigDecimal('15.90'))
    end
  end
end