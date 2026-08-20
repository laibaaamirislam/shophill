puts "Cleaning existing records..."

# Clear dependent records in safe order
Invoice.destroy_all
OrderItem.destroy_all
Order.destroy_all
CartItem.destroy_all
Cart.destroy_all
Product.destroy_all
Category.destroy_all
Customer.destroy_all
AdminUser.destroy_all

puts "Creating Admin and Customer accounts..."

# Default Admin Account (using AdminUser model)
AdminUser.create!(
  name: "Store Admin",
  email: "admin@shophill.com",
  password: "password123",
  password_confirmation: "password123"
)

# Default Test Customer
customer = Customer.create!(
  name: "Test Customer",
  email: "customer@example.com",
  password: "password123",
  password_confirmation: "password123",
  address: "123 Main Street",
  city: "Lahore",
  postal_code: "54000",
  phone: "+923001234567"
)
customer.create_cart!

puts "Creating Categories..."

electronics = Category.create!(name: "Electronics", slug: "electronics", description: "Gadgets and tech accessories")
apparel     = Category.create!(name: "Apparel & Fashion", slug: "apparel-fashion", description: "Clothing and everyday wear")
home        = Category.create!(name: "Home & Living", slug: "home-living", description: "Home decor and kitchenware")
accessories = Category.create!(name: "Accessories", slug: "accessories", description: "Bags, watches, and gear")

puts "Creating Products..."

products = [
  # Electronics
  {
    name: "Wireless Noise-Canceling Headphones",
    description: "Premium over-ear headphones with active noise cancellation and 30-hour battery life.",
    price_cents: 19999, # $199.99
    stock_quantity: 25,
    active: true,
    category: electronics
  },
  {
    name: "Ergonomic Mechanical Keyboard",
    description: "Tactile mechanical switches with customizable RGB backlighting and wrist rest.",
    price_cents: 8999, # $89.99
    stock_quantity: 12,
    active: true,
    category: electronics
  },
  {
    name: "Ultra-Fast Wireless Charger Pad",
    description: "15W fast charging pad compatible with all Qi-enabled iOS and Android devices.",
    price_cents: 2499, # $24.99
    stock_quantity: 40,
    active: true,
    category: electronics
  },

  # Apparel
  {
    name: "Minimalist Oversized Cotton Hoodie",
    description: "Heavyweight 100% organic cotton hoodie with a cozy fleece interior.",
    price_cents: 5499, # $54.99
    stock_quantity: 18,
    active: true,
    category: apparel
  },
  {
    name: "Classic Denim Jacket",
    description: "Timeless vintage wash denim jacket built for durable everyday wear.",
    price_cents: 7499, # $74.99
    stock_quantity: 8,
    active: true,
    category: apparel
  },

  # Home & Living
  {
    name: "Ceramic Pour-Over Coffee Maker",
    description: "Handcrafted ceramic dripper designed for optimal heat retention and smooth brewing.",
    price_cents: 3200, # $32.00
    stock_quantity: 15,
    active: true,
    category: home
  },
  {
    name: "Scented Soy Wax Candle",
    description: "Natural soy wax candle with essential oils providing 45+ hours of burn time.",
    price_cents: 1850, # $18.50
    stock_quantity: 30,
    active: true,
    category: home
  },

  # Accessories
  {
    name: "Waterproof Canvas Backpack",
    description: "Spacious 20L travel backpack featuring a padded 15-inch laptop sleeve.",
    price_cents: 6499, # $64.99
    stock_quantity: 3, # Low stock test
    active: true,
    category: accessories
  },
  {
    name: "Polarized Stainless Sunglasses",
    description: "UV400 protection polarized lenses housed in lightweight stainless steel frames.",
    price_cents: 3999, # $39.99
    stock_quantity: 0, # Out-of-stock test
    active: true,
    category: accessories
  }
]

products.each do |product_attrs|
  Product.create!(product_attrs)
end

puts "Database seeded successfully!"
puts "------------------------------------------------"
puts "Admin User Credentials: admin@shophill.com / password123"
puts "Customer Credentials:   customer@example.com / password123"
puts "Total Categories:       #{Category.count}"
puts "Total Products:         #{Product.count}"
puts "------------------------------------------------"