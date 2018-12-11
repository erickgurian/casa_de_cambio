require 'sqlite3'

class Cashier

  attr_accessor :dollar, :real, :price, :date, :operator

  @@db = SQLite3::Database.open "cambio.db"


  def initialize(dollar, real, price, operator)
    @dollar = dollar
    @real = real
    @price = price
    @date = DateTime.now.strftime('%Y-%m-%d')
    @operator = operator
  end


  def valid? (have, want)
    return false if have < want
    true
  end

  def accepted?
    answer = gets.chomp.downcase
    answer == 'sim' ? true : false
  end

  def self.check_cashier(operator)
    @@db.execute("SELECT dollar, real, price, operator FROM cashiers WHERE operator = '#{operator}'")
  end


  def self.check_date(operator)
    dt = DateTime.now.strftime('%Y-%m-%d')
    @@db.execute("SELECT dollar, real, price, operator FROM cashiers WHERE operator = '#{operator}' AND date = #{dt}")
  end


  def save_cashier
    @@db.execute("INSERT INTO cashiers (dollar, real, price, date, operator) values (?, ?, ?, ?, ?)",
                [self.dollar, self.real, self.price, self.date, self.operator])
  end

  def update_cashier
    @@db.execute("UPDATE cashiers SET dollar = #{self.dollar}, real = #{self.real}, price = #{self.price}, date = #{self.date} WHERE operator = '#{self.operator}'")
  end


  def buy_dollar(qtdDollar)
    priceDollar = (qtdDollar * self.price).round(2)
    if !valid?(self.real, priceDollar)
      puts
      puts 'Você não possui dinheiro suficente para realizar essa operação!'
    else
      print "Tem certeza que deseja comprar $#{qtdDollar} por R$#{priceDollar}? [Sim | Não]: "
      if accepted?
        self.real -= priceDollar
        self.dollar += qtdDollar
        puts
        puts 'Transação efetuada com sucesso!'
        transaction = Transactions.new('Compra', 'Dólar', self.price, qtdDollar)
        @@db.execute("INSERT INTO transactions(action, coin, price, value, operator, date) values(?, ?, ?, ?, ?, ?)",
                    [transaction.action, transaction.coin, transaction.price, transaction.value], self.operator, self.date)
      else
        puts 'Operação Cancelada!'
      end
    end
  end


  def sell_dollar(qtdDollar)
    qtdReal = (qtdDollar * self.price).round(2)
    if !valid?(self.dollar, qtdDollar)
      puts
      puts 'Você não possui dinheiro suficiente para realizar esa operação!'
    else
      print "Tem certeza que deseja vender $#{qtdDollar} por R$#{qtdReal}? [Sim | Não]: "
      if accepted?
        self.dollar -= qtdDollar
        self.real += qtdReal
        puts
        puts 'Transação efetuada com sucesso!'
        transaction = Transactions.new('Venda', 'Dólar', self.price, qtdDollar)
        @@db.execute("INSERT INTO transactions(action, coin, price, value, operator, date) values(?, ?, ?, ?, ?, ?)",
                    [transaction.action, transaction.coin, transaction.price, transaction.value], self.operator, self.date)
      else
        puts 'Operação Cancelada!'
      end
    end
  end


  def buy_real(qtdReal)
    qtdDollar = (qtdReal / self.price).round(2)
    if !valid?(self.dollar, qtdDollar)
      puts
      puts 'Você não possui dinheiro suficiente para realizar essa operação!'
    else
      print "Tem certeza que deseja comprar R$ #{qtdReal} por $ #{qtdDollar}? [Sim | Não]: "
      if accepted?
        self.dollar -= qtdDollar
        self.real += qtdReal
        puts 'Transação efetuada com sucesso!'
        transaction = Transactions.new('Compra', 'Real', self.price, qtdDollar)
        @@db.execute("INSERT INTO transactions(action, coin, price, value, operator, date) values(?, ?, ?, ?, ?, ?)",
                    [transaction.action, transaction.coin, transaction.price, transaction.value], self.operator, self.date)
      else
        puts 'Operação Cancelada!'
      end
    end
  end


  def sell_real(qtdReal)
    qtdDollar = (qtdReal / self.price).round(2)
    if !valid?(self.real, qtdReal)
      puts
      puts 'Você não possui dinheiro suficiente para realizar essa operação!'
    else
      print "Tem certeza que deseja vender R$ #{qtdReal} por $ #{qtdDollar}? [Sim | Não]: "
      if accepted?
        self.dollar += qtdDollar
        self.real -= qtdReal
        puts
        puts 'Transação efetuada com sucesso!'
        transaction = Transactions.new('Venda', 'Real', self.price, qtdDollar)
        @@db.execute("INSERT INTO transactions(action, coin, price, value, operator, date) values(?, ?, ?, ?, ?, ?)",
                    [transaction.action, transaction.coin, transaction.price, transaction.value], self.operator, self.date)
      else
        puts 'Operação Cancelada!'
      end
    end
  end


  def show_operations
    transactions = @@db.execute("SELECT id, action, coin, price, value, operator, date
                                FROM transactions WHERE operator = '#{self.operator}' AND date = '#{self.date}' ")
    table = Terminal::Table.new do |t|
      t.headings = 'Id', 'Tipo Operação', 'Moeda', 'Cotação', 'Valor', 'Operador', 'Data'
      transactions.each do |ts|
        t << ts
      end
    end
    puts table
  end


  def status
    table =  Terminal::Table.new do |t|
      t.headings = 'Data', 'Operador', 'Cotação Atual', 'Saldo Dólares', 'Saldo Reais'
      t << ["#{self.date}", "#{self.operator}", "$ 1,00 = #{self.price}",  "$ #{self.dollar}", "R$ #{self.real}"]
    end
    puts table
  end


  def exit_cashier
    @@db.close
    exit 0
  end
end
