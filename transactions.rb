class Transactions
  attr_accessor :id, :action, :coin, :price, :value

  @@last_id = 0

  def initialize(action, coin, price, value)
    @id = @@last_id + 1
    @action = action
    @coin = coin
    @price = price
    @value = value
    @@last_id = @id
  end

  def to_s
    "#{@id} | #{@action} | #{@coin} | $1.00 = R$#{@price} | $#{@value}"
  end

end
