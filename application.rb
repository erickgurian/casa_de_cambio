require_relative 'cashier'
require_relative 'transactions'
require 'terminal-table'

class Application

  def init
    print 'Nome do Operador: '
    operator = gets.chomp
    last_operator = Cashier.check_cashier(operator)

    #Verifica se o operador atual já existe no bd
    if (!last_operator.empty?)
      puts 'Operador Encontrado! Buscando a data atual...'
      last_date = Cashier.check_date(operator)
      #Caso encontrado, checa se há dados para a data atual
      #Se houver, carrega o caixa com os dados e pergunta se deseja atualizá-los
      if(!last_date.empty?)
        cashier = Cashier.new(last_date[0][0], last_date[0][1], last_date[0][2], last_date[0][3])
        puts "Valores encontrados para #{operator} na data atual:"
        cashier.status
        puts
        print 'Deseja atualizar os valores? [Sim | Não]:'
        resposta = gets.chomp

        case(resposta)

        when 'sim'
          puts 'Cotação atual do dólar:'
          print '$1,00 = R$ '
          cashier.price = gets.to_f
          print 'Dolares disponíveis: $ '
          cashier.dollar = gets.to_f
          print 'Reais disponívels: R$ '
          cashier.real = gets.to_f
          puts
          puts 'Tudo Pronto! Podemos começar!'
          cashier.update_cashier
        when 'não'
          puts 'Valores Mantidos!'
        else
          puts 'Opção Inválida! Os valores serão mantidos!'
        end
      #Caso encontre o caixa mas não a data, atualiza os valores para essa nova data
      else
        puts 'Nenhum valor para esta data! Atualize agora!'
        cashier = Cashier.new(last_operator[0][0], last_operator[0][1], last_operator[0][2], last_operator[0][3])
        puts 'Cotação atual do dólar:'
        print '$1,00 = R$ '
        cashier.price = gets.to_f
        print 'Dolares disponíveis: $ '
        cashier.dollar = gets.to_f
        print 'Reais disponívels: R$ '
        cashier.real = gets.to_f
        puts
        puts 'Tudo Pronto! Podemos começar!'
        cashier.date = DateTime.now.strftime('%Y-%m-%d')
        cashier.update_cashier
      end
    #Por fim, se não houver operador cadastrado, cria um novo
    else
      puts 'Nenhum caixa encontrado'
      puts 'Inicializando...'
      puts 'Cotação atual do dólar:'
      print '$1,00 = R$ '
      price = gets.to_f
      print 'Dolares disponíveis: $ '
      dollar = gets.to_f
      print 'Reais disponívels: R$ '
      real = gets.to_f
      puts
      puts 'Tudo Pronto! Podemos começar!'
      cashier = Cashier.new(dollar.round(2), real.round(2), price.round(2), operator)
      cashier.save_cashier
    end
    cashier
  end


  def menu
    puts
    puts 'Bem vindo a casa de câmbio! Escolha uma opção do menu: '
    puts '[1] Comprar dólares'
    puts '[2] Vender dólares'
    puts '[3] Comprar reais'
    puts '[4] Vender reais'
    puts '[5] Ver operações do dia;'
    puts '[6] Ver situação do caixa'
    puts '[7] Sair'
    print 'Opção: '
    gets.to_i
  end

  def enter
    puts 'Pressione enter para continuar'
    gets
  end

  def clear
    system('clear')
  end

  def start
    op = init
    loop do
      case menu
        when 1
          print 'Quantos dólares deseja comprar: $ '
          qtdDollar = gets.to_f
          op.buy_dollar(qtdDollar)
          enter
          clear
        when 2
          print 'Quantos dólares deseja vender: $'
          qtdDollar = gets.to_f
          op.sell_dollar(qtdDollar)
          enter
          clear
        when 3
          print 'Quantos reais deseja comprar: R$ '
          qtdReal = gets.to_f
          op.buy_real(qtdReal)
          enter
          clear
        when 4
          print 'Quantos reais deseja vender: R$'
          qtdReal = gets.to_f
          op.sell_real(qtdReal)
          enter
          clear
        when 5
          puts
          puts 'Operações do dia: '
          op.show_operations
          enter
          clear
        when 6
          puts
          op.status
          enter
          clear
        when 7
          clear
          op.update_cashier
          op.exit_cashier
        else
          puts 'Opção Inválida!'
          puts
          enter
          clear
      end
    end
  end

end
