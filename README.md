# Acme Widget Co

Also available via YARD dcoumentation: [https://mufid.github.io/cart_calculator/doc/index.html](https://mufid.github.io/cart_calculator/doc/index.html)

## Original Instruction

Acme Widget Co are the leading provider of made up widgets and they’ve contracted you to create a proof of concept
for their new sales system. They sell three products: 

| Product      | Code | Price     |
|--------------|------|-----------|
| Red Widget   | R01  | $32.95    |
| Green Widget | G01  | $24.95    |
| Blue Widget  | B01  | $7.95     |

To incentivise customers to spend more, delivery costs are reduced based on the amount spent.

- Orders under $50 cost $4.95.
- For orders under $90, delivery costs $2.95.
- Orders of $90 or more have free delivery.

They are also experimenting with special offers. The initial offer will be “buy one red widget, get the second half price”.  

Your job is to implement the basket which needs to have the following interface 

- It is initialised with the product catalogue, delivery charge rules, and offers (the format of how these are passed 
  it up to you)  
- It has an add method that takes the product code as a parameter.
- It has a total method that returns the total cost of the basket, taking into account 
  the delivery and offer rules. 

Here are some example baskets and expected totals to help you check your  implementation.  

| Products                 | Total  |
|--------------------------|--------|
| B01, G01                 | $37.85 |
| R01, R01                 | $54.37 |
| R01, G01                 | $60.85 |
| B01, B01, R01, R01, R01  | $98.27 |

## Implementation

### Usage

The cart calculator is implemented as a command-line interface (CLI) application. To use it:

#### Running the CLI

```bash
# Run the interactive cart calculator
bin/cart_calculator
```

The CLI provides a REPL (Read-Eval-Print Loop) interface where you can:

- Enter product codes separated by spaces (e.g., `B01 G01 R01`)
- View the order summary with subtotal, discounts, delivery charges, and grand total
- Type `exit` to quit the application

#### Example Session

```
$ bin/cart_calculator
Welcome to Cart Calculator!
Enter product codes separated by spaces (e.g., 'B01 B01 G01')
Type 'exit' to quit

> B01 G01

Order Summary:
----------------------------------------
Blue Widget (B01) x1: $7.95
Green Widget (G01) x1: $24.95
----------------------------------------
Subtotal: $32.90
Delivery: $4.95
----------------------------------------
Grand Total: $37.85

> R01 R01

Order Summary:
----------------------------------------
Red Widget (R01) x2: $65.90
----------------------------------------
Subtotal: $65.90
Discount: -$16.48
Delivery: $4.95
----------------------------------------
Grand Total: $54.37

> exit
Thank you for using Cart Calculator!
```

### Architecture

The application follows a modular architecture with clear separation of concerns:

#### Models Module

All domain models are organized under the `CartCalculator::Models` namespace:

- **Product**: Represents a product with code, name, and price (stored as BigDecimal for precision)
- **LineItem**: Represents a product in the cart with its quantity
- **Cart**: The main domain model that orchestrates products, discounts, and delivery charges
- **Catalogue**: Provides the product inventory (currently as a DEFAULT constant)
- **DeliveryRule**: Defines delivery charge rules based on order amount ranges

This namespace separation clearly distinguishes domain models from infrastructure concerns like CLI or persistence.

#### CLI Module

The CLI functionality is separated into two classes:

1. **Runner**: Orchestrates the REPL loop and display logic
2. **IO**: Wraps all input/output operations

**Why separate IO from Runner?**

- **Testability**: The IO wrapper allows easy unit testing with mock objects
- **Flexibility**: Input/output can be redirected (files, network streams) without changing the runner
- **Single Responsibility**: Each class has one clear purpose
- **Dependency Injection**: The runner accepts an IO object, making it configurable and testable

#### Key Design Principles

1. **Dependency Injection**: Cart accepts its dependencies (catalogue, delivery rules, offers) through constructor injection
2. **Configuration through Constants**: DEFAULT constants provide sensible defaults while allowing custom configurations
3. **Immutable Configuration**: Frozen constants ensure configuration integrity
4. **Separation of Concerns**: Each class has a single, well-defined responsibility

### Tests

The test suite includes comprehensive unit tests and integration tests:

#### Unit Tests

**Product Tests** (`spec/cart_calculator/product_spec.rb`):

- Validates product initialization with code, name, and price
- Ensures price is stored as BigDecimal for precision
- Validates that price must be passed as a string

**LineItem Tests** (`spec/cart_calculator/line_item_spec.rb`):

- Tests initialization with quantity of 1
- Validates quantity increment functionality
- Tests subtotal calculation (price × quantity)

**Cart Tests** (`spec/cart_calculator/cart_spec.rb`):

- Tests adding products to cart
- Validates quantity increment for duplicate products
- Tests error handling for invalid product codes
- Validates all example calculations from requirements
- Tests delivery charge rules for different order amounts
- Validates red widget discount offer

**CLI Runner Tests** (`spec/cart_calculator/cli/runner_spec.rb`):

- Tests the REPL flow with mocked IO
- Validates order processing and display
- Tests error handling for invalid products
- Tests empty input handling
- Validates discount display

#### Integration Tests

The integration test suite (`spec/cart_calculator/integration/integration_spec.rb`) uses an innovative file-based approach:

- **Example Files**: Input/output pairs in `spec/examples/` (e.g., `01-in.txt` and `01-out.txt`)
- **Dynamic Test Generation**: Automatically creates a test for each example file pair
- **Full Stack Testing**: Tests the entire application flow from input to output
- **Easy to Extend**: New test cases can be added by simply creating new file pairs

This approach ensures the CLI behaves exactly as expected in real-world usage.

### Documentation

The codebase includes comprehensive documentation using YARD comments. All classes and methods are documented with:

- Clear descriptions of purpose and functionality
- Parameter types and return values
- Usage examples
- Architecture notes for key classes (Cart and Runner)

#### Generating Documentation

To generate the HTML documentation:

```bash
# Install YARD if not already installed
gem install yard

# Generate documentation
yard doc
```

#### Viewing Documentation

After generation, the documentation is available in the `doc/` folder:

```bash
# Open the documentation in your browser
open doc/index.html
```

The documentation includes:

- **Class Overview**: All classes with their responsibilities
- **Method Documentation**: Detailed information about each method
- **Code Examples**: Runnable examples showing how to use each component
- **Architecture Notes**: In-depth explanations of design decisions for Cart and Runner classes

YARD documentation provides a navigable, searchable reference that complements this README with detailed API documentation.

### Assumptions

The current implementation makes several assumptions that deviate from typical Rails practices:

**Static Configuration via Constants**

- Products, delivery rules, and offers are defined as frozen constants
- **Rationale**: Simplifies the proof of concept
- **Alternative**: Could easily be refactored to accept dynamic configuration or read from a database

**No Persistence Layer**

- The cart exists only in memory during the CLI session
- **Alternative**: Could implement a repository pattern to persist carts to SQL/NoSQL databases

**Simple Offer System**

- Currently hardcoded for "red widget half price" offer
- **Alternative**: Could implement a strategy pattern for flexible offer rules

**BigDecimal for All Monetary Values**

- Prices are required as strings to maintain precision
- **Rationale**: Prevents floating-point precision issues
- **Note**: This is actually a best practice, not a deviation

**No Authentication or Multi-tenancy**

- Single-user CLI application
- **Alternative**: Could add user sessions and multi-cart support

**Minimal Error Handling**

- Only handles invalid product codes
- **Alternative**: Could add validation for negative quantities, concurrent modifications, etc.

**No Internationalization**

- Currency is hardcoded as dollars
- **Alternative**: Could use Money gem or similar for multi-currency support

These assumptions are appropriate for a proof of concept but would need to be addressed for a production system. The modular architecture makes it easy to evolve the system as requirements grow.


