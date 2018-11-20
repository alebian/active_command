# Active Command

```ruby
class Wallet
  attr_reader :balance

  def initialize(balance = 0.0)
    @balance = balance
  end

  def increase_balance(amount)
    @balance += amount
  end
end

class IncreaseWalletsBalance < ActiveCommand::Base
  required :wallets, type: Types::Array.of(Types.Instance(Wallet))
  required :amount, type: Types::Integer

  before do
    raise ArgumentError if wallets.any?(&:nil?)
  end

  def call
    wallets.each do |wallet|
      wallet.increase_balance(amount)
    end
  end

  after do
    puts 'Done'
  end
end

IncreaseWalletsBalance.call(wallets: [Wallet.new], amount: 1)
```

https://dry-rb.org/gems/dry-types/
