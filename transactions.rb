require 'sqlite3'

class Transactions
  attr_accessor :id, :action, :coin, :price, :value

  @@db = SQLite3::Database.open "cambio.db"
  @@id_db = @@db.execute("SELECT MAX(id) FROM transactions")

  if !@@id_db.any?
    @@last_id = @@id_db[0].to_i
  else
    @@last_id = 0
  end

  def initialize(action, coin, price, value)
    @id = @@last_id + 1
    @action = action
    @coin = coin
    @price = price
    @value = value
  end

  def to_s
    "#{@id} | #{@action} | #{@coin} | $1.00 = R$#{@price} | $#{@value}"
  end

end
