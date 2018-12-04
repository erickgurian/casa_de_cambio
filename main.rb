require_relative 'methods'
require_relative 'transactions'
require 'terminal-table'

op = Methods.init
opcao = Methods.menu()

while (opcao != 7) do

  if opcao == 1
    puts 'Quantos dólares deseja comprar: '
    qtdDollar = gets.to_f
    op.buy_dollar(qtdDollar)

  elsif opcao == 2
    puts 'Quantos dólares deseja vender: '
    qtdDollar = gets.to_f
    op.sell_dollar(qtdDollar)

  elsif opcao == 3
    puts 'Quantos reais deseja comprar?'
    qtdReal = gets.to_f
    op.buy_real(qtdReal)

  elsif opcao == 4
    puts 'Quantos reais deseja vender?'
    qtdReal = gets.to_f
    op.sell_real(qtdReal)

  elsif opcao == 5
    puts
    puts 'Operações do dia: '
    op.show_operations

  elsif opcao == 6
    puts
    op.status

  else
    puts
    puts 'Opção Inválida!'
    puts
  end

  opcao = Methods.menu

end

op.save
