class Cashier

  attr_accessor :dollar, :real, :price, :operations

  def initialize(dollar, real, price)
    @dollar = dollar
    @real = real
    @price = price
    @operations = []
  end


  def valid? (have, want)
    if have < want
      false
    else
      true
    end
  end

  def accepted? (answer)
    if answer.downcase == 'sim' || answer.downcase == 'yes'
      true
    else
      false
    end
  end


  def buy_dollar(qtdDollar)
    priceDollar = (qtdDollar * @price).round(2)
    if !valid?(@real, priceDollar)
      puts
      puts 'Você não possui dinheiro suficente para realizar essa operação!'
    else
      puts "Tem certeza que deseja comprar $#{qtdDollar} por R$#{priceDollar}? [Sim | Não]"
      answer = gets.chomp
      if accepted?(answer)
        @real -= priceDollar
        @dollar += qtdDollar
        puts
        puts 'Transação efetuada com sucesso!'
        operations << Transactions.new('Compra', 'Dólar', @price, qtdDollar)
      else
        puts 'Operação Cancelada!'
      end
    end
  end


  def sell_dollar(qtdDollar)
    qtdReal = (qtdDollar * @price).round(2)
    if !valid?(@dollar, qtdDollar)
      puts
      puts 'Você não possui dinheiro suficiente para realizar esa operação!'
    else
      puts "Tem certeza que deseja vender $#{qtdDollar} por R$#{qtdReal}? [Sim | Não]"
      answer = gets.chomp
      if accepted?(answer)
        @dollar -= qtdDollar
        @real += qtdReal
        puts
        puts 'Transação efetuada com sucesso!'
        operations << Transactions.new('Venda', 'Dólar', @price, qtdDollar)
      else
        puts 'Operação Cancelada!'
      end
    end
  end

  def buy_real(qtdReal)
    qtdDollar = (qtdReal / @price).round(2)
    if !valid?(@dollar, qtdDollar)
      puts
      puts 'Você não possui dinheiro suficiente para realizar essa operação!'
    else
      puts "Tem certeza que deseja comprar R$ #{qtdReal} por $ #{qtdDollar}? [Sim | Não]"
      answer = gets.chomp
      if accepted?(answer)
        @dollar -= qtdDollar
        @real += qtdReal
        puts 'Transação efetuada com sucesso!'
        operations << Transactions.new('Compra', 'Real', @price, qtdDollar)
      else
        puts 'Operação Cancelada!'
      end
    end
  end


  def sell_real(qtdReal)
    qtdDollar = (qtdReal / @price).round(2)
    if !valid?(@real, qtdReal)
      puts
      puts 'Você não possui dinheiro suficiente para realizar essa operação!'
    else
      puts "Tem certeza que deseja vender R$ #{qtdReal} por $ #{qtdDollar}? [Sim | Não]"
      answer = gets.chomp
      if accepted? (answer)
        @dollar += qtdDollar
        @real -= qtdReal
        puts
        puts 'Transação efetuada com sucesso!'
        operations << Transactions.new('Venda', 'Real', @price, qtdDollar)
      else
        puts 'Operação Cancelada!'
      end
    end
  end


  def show_operations
    user_table = Terminal::Table.new do |t|
      t.headings = 'Id', 'Tipo Operação', 'Moeda', 'Cotação', 'Valor'
      @operations.each do |op|
        t << op.to_s.split(" | ")
      end
    end
    puts user_table
  end


  def status
    user_table =  Terminal::Table.new do |t|
      t.headings = 'Cotação Atual', 'Saldo Dólares', 'Saldo Reais'
      t << ["$ 1,00 = #{@price}",  "$ #{@dollar}", "R$ #{@real}"]
    end
    puts user_table
  end

  def save
    File.open('operations.txt', 'a+') do |file|
      file.puts(Time.now)
      @operations.each do |op|
        file.puts(op)
      end
    end
  end

end