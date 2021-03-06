require 'csv'

# Nouns
# ✅ name
# ✅ account_number
# ✅ routing_number
# ✅ type (checking or savings)
# ✅ balance

# Verbs
# ✅ check balance
# ✅ withdraw
#   What information does this need?
#     - how much
#     - current balance
#   What work do we need to do?
#     - subtract how much to the current balance and put in new balance
#     - store that in the current balance
#   Output (return)
#     - return the new balance
# ✅ deposit
#   What information does this need?
#     - how much
#     - current balance
#   What work do we need to do?
#     - add how much to the current balance
#     - store that in the current balance
#   Output (return)
#     - return the new balance
#   - interest deposit
# transfer
class BankAccount
  attr_reader "name", "balance", "account_number", "routing_number", "type"

  def initialize(name, account_number, routing_number, type, balance)
    @balance = balance
    @name = name
    @account_number = account_number
    @routing_number = routing_number
    @type = type
  end

  # withdraw
  #   What information does this need?
  #     - how much
  #     - current balance
  #   What work do we need to do?
  #   Output (return)
  #     - return the new balance
  def withdraw(amount)
    if amount < 0
      puts "Nice try hacker!"
    else
      #     - subtract how much from the current balance and put in new balance
      new_balance = @balance - amount
      #     - store that in the current balance
      @balance = new_balance
    end

    return @balance
  end

  # deposit
  #   What information does this need?
  #     - how much (amount)
  #     - current balance
  #   What work do we need to do?
  #   Output (return)
  #     - return the new balance
  def deposit(amount)
    if amount < 0
      puts "What? really?"
    else
      puts "-- Transaction log. Depositing #{amount} into #{@name} account (#{@type}) with a current balance of #{@balance}"
      #     - add how much to the current balance
      new_balance = amount + @balance
      #     - store that in the current balance
      @balance = new_balance
    end

    return @balance
  end
end

class Bank
  def initialize
    @accounts = []
    CSV.foreach("accounts.csv", headers: true) do |row|
      name = row["name"]
      balance = row["balance"].to_i
      account_number = row["account_number"].to_i
      routing_number = row["routing_number"].to_i
      type = row["type"]

      account = BankAccount.new(name, account_number, routing_number, type, balance)

      @accounts << account
    end
  end

  def menu
    loop do
      puts "What is the person's name?"
      name = gets.chomp

      if name.empty?
        break
      end

      puts "What is their account number?"
      account_number = gets.chomp.to_i

      puts "What is their routing number?"
      routing_number = gets.chomp.to_i

      puts "What is their account type"
      type = gets.chomp

      puts "What is their balance?"
      balance = gets.chomp.to_i

      account = BankAccount.new(name, account_number, routing_number, type, balance)
      puts "The #{account.type} balance for #{account.name}'s account is #{account.balance}"

      @accounts << account
    end

    # Better write out that CSV file here....
  end

  def number_of_accounts
    return @accounts.count
  end

  def total_balance
    # Go through each account at the bank (accounts)
    total_balance = 0
    @accounts.each do |account|
      total_balance += account.balance
    end

    return total_balance
  end

  def total_checking_balance
    total = 0

    # Makes a new array of JUST the checking accounts
    # checking_accounts = []
    # @accounts.each do |account|
    #   if account.type == "checking"
    #     checking_accounts << account
    #   end
    # end

    # Using the `select` enumerable, but not using the Jim Weirich rule
    # since we *do* care about the result of the `select`
    # checking_accounts = @accounts.select do |account|
    #   account.type == "checking"
    # end

    checking_accounts = @accounts.select { |account| account.type == "checking" }

    total = 0
    checking_accounts.each do |account|
      total += account.balance
    end

    return total
  end
end

bank = Bank.new

bank.menu

puts "The bank has #{bank.number_of_accounts} accounts."
puts "The total balance is #{bank.total_balance}"
puts "The total checking balance is #{bank.total_checking_balance}"

#
