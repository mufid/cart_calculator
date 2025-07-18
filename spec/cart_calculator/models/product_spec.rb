RSpec.describe CartCalculator::Models::Product do
  subject(:product) do
    described_class.new(code: 'R01', name: 'Red Widget', price: '32.95')
  end

  describe "#initialize" do
    it "sets the code" do
      expect(product.code).to eq('R01')
    end

    it "sets the name" do
      expect(product.name).to eq('Red Widget')
    end

    it "sets the price as BigDecimal" do
      expect(product.price).to eq(BigDecimal('32.95'))
    end

    it "raises an error if price is not a string" do
      expect {
        described_class.new(code: 'R01', name: 'Red Widget', price: 32.95)
      }.to raise_error(ArgumentError, 'Price must be a string')
    end
  end
end