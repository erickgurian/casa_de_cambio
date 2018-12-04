class Methods

  def self.menu
    puts
    puts 'Bem vindo a casa de câmbio! Escolha uma opção do menu: '
    puts '[1] Comprar dólares'
    puts '[2] Vender dólares'
    puts '[3] Comprar reais'
    puts '[4] Vender reais'
    puts '[5] Ver operações do dia;'
    puts '[6] Ver situação do caixa'
    puts '[7] Salvar e Sair'
    print 'Opção: '
    gets.to_i
  end

  def self.init
    puts 'Inicializando...'
    puts 'Cotação atual do dólar:'
    print '$1,00 = R$ '
    price = gets.to_f
    print 'Dolares disponíveis: '
    dollar = gets.to_f
    print 'Reais disponívels: '
    real = gets.to_f
    op = Transactions.new(dollar.round(2), real.round(2), price.round(2))
    puts
    puts 'Tudo Pronto! Podemos começar!'
    op
  end
end
