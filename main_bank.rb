require 'io/console'
require_relative 'bank_classes'

@attempts = 0

@customers = []
if File.zero?("customers.txt") == false
	saved_customers = File.open("customers.txt", "r") {|from_file| Marshal.load(from_file)}
	@customers += saved_customers
end

@accounts = []
if File.zero?("accounts.txt") == false
	saved_accounts = File.open("accounts.txt", "r") {|from_file| Marshal.load(from_file)}
	@accounts += saved_accounts
end

##############################################
# Methods that deal with Customer class only #
##############################################

def sign_in
	puts "Please choose:\n1. Sign In\n2. New Customer"
	choice = gets.chomp.to_i

	if choice == 1
		pin_entry
	elsif choice == 2
		new_cust_reg
	else
		puts `clear`
		puts "Invalid response."
		sign_in
	end
end

def pin_entry
	if @attempts <= 3
		print "Please enter your 4-digit PIN (your PIN will be hidden): "
		pin = STDIN.noecho(&:gets).chomp
		customer_found = false
		@customers.each do |cust|
			if pin == cust.pin
				customer_found = true
				current_cust = cust
				puts `clear`
				main_menu(cust)
			end
		end
		if customer_found == false
			@attempts += 1
			puts `clear`
			puts "Incorrect PIN. Please try again."
			pin_entry
		end
	else
		puts "Max number of attempts reached. Please try again later."
		# program should stop here
	end
end

def new_cust_reg
	puts "Welcome new customer!\nPlease provide the following information:"
	print "Your first name: "
	firstname = gets.chomp
	print "Your last name: "
	lastname = gets.chomp
	print "Choose a 4-digit PIN: "
	pin = gets.chomp
	new_customer = Customer.new(firstname,lastname,pin)
	@customers.push(new_customer)
	File.open("customers.txt", "w"){|f| f.write(Marshal.dump(@customers))}
	puts `clear`
	puts "New customer succesfully registered!"
	main_menu(new_customer)
end

def main_menu(customer)
	puts "Welcome back, #{customer.fullname}!\nPlease choose from the following selections: "
	puts "-------------------"
	puts "1. Create an Account"
	puts "2. Account Menu"
	puts "3. End Session"

	choice = gets.chomp.to_i

	if choice == 1
		create_account(customer)
	elsif choice == 2
		account_lookup(customer)
	elsif choice == 3
		end_session
	else
		puts `clear`
		puts "Not a valid selection."
		main_menu(customer)
	end
end

#################################
# Methods dealing with Accounts #
#################################

def create_account(customer)
	acct_type = choose_account_type
	print "Your initial deposit will be? $"
	balance = gets.chomp.to_f
	acct_num = @accounts.length + 1
	new_account = Account.new(customer, balance, acct_type, acct_num)
	@accounts.push(new_account)

	puts "Account created succesfully! \n#{new_account.customer.fullname} \nAccount no. #{new_account.acct_num} (#{new_account.acct_type}) \n$#{'%.2f' % new_account.balance}"

	return_to_main_menu(customer)
end

def choose_account_type
	puts "What type of account would you like to open?"
	puts "1. Checking\n2. Savings\n3. Money Market"
	acct_type = gets.chomp.to_i
	case acct_type
		when 1
			acct_type = "Checking"
		when 2
			acct_type = "Savings"
		when 3
			acct_type = "Money Market"
		else
			puts `clear`
			puts "Not a valid selection"
			choose_account_type
	end
	return acct_type
end

def account_lookup(customer)
	puts `clear`
	customer_accounts = []
	account_found = false
	@accounts.each do |acct|
		if customer.fullname == acct.customer.fullname
			customer_accounts.push(acct)
			account_found = true
		end
	end

	if account_found == false
		puts "No matching accounts found."
		puts "Try again? [y/n]"
		choice = gets.chomp.downcase
		choice == "y" ? account_lookup : main_menu(customer)
	else
		puts "Which account do you want to access?"
		count = 0
		while count < customer_accounts.length
			puts "#{count + 1}. #{customer_accounts[count].acct_type}"
			count += 1
		end
		choice = gets.chomp.to_i - 1

		account_menu(customer_accounts[choice])
	end
end

def account_menu(acct)
	puts "Choose from the following: "
	puts "-------------------------- "
	puts "1. Check Balance"
	puts "2. Make a Deposit"
	puts "3. Make a Withdrawal"
	puts "4. Return to Main Menu"

	choice = gets.chomp.to_i

	case choice
		when 1
			check_balance(acct)
		when 2
			make_deposit(acct)
		when 3
			make_withdrawal(acct)
		when 4
			main_menu(acct.customer)
		else
			puts `clear`
			puts "Not a valid selection."
			account_menu(acct)
	end
end

def check_balance(acct)
	puts `clear`
	puts "Current balance: $#{'%.2f' % acct.balance}"
	return_to_account_menu(acct)
end

# LEFT OFF HERE
def make_deposit(acct)
	puts "How much would you like to deposit today?"
	deposit = gets.chomp.to_f

	acct.deposit(deposit)

	puts "Your balance is now $#{'%.2f' % acct.balance}"

	return_to_account_menu(acct)
end

def make_withdrawal(acct)
	puts "How much would you like to withdrawal today?"
	withdrawal = gets.chomp.to_f

	if withdrawal > acct.balance
		puts "Insufficient funds."
		puts "Account balance: #{'%.2f' % acct.balance}"
		puts "Please make a smaller withdrawal."
		sleep(5)
		make_withdrawal(acct)
	else
		acct.withdrawal(withdrawal)

		puts "Your balance is now $#{'%.2f' % acct.balance}"

		return_to_account_menu(acct)
	end
end

def return_to_account_menu(acct)
	puts "Return to the Account Menu? [y/n]"
	choice = gets.chomp.downcase
	if choice == "y"
		puts `clear`
		account_menu(acct)
	else
		puts `clear`
		end_session
	end
end

def return_to_main_menu(customer)
	puts "Return to Main Menu? [y/n]"
	choice = gets.chomp.downcase
	if choice == "y"
		puts `clear`
		main_menu(customer)
	else
		puts `clear`
		end_session
	end
end

def end_session
	File.open("accounts.txt", "w"){|f| f.write(Marshal.dump(@accounts))}
	puts `clear`
	puts "Thank you for banking with us.\nGoodbye"
	# program stops
end

def session_timeout
	# End session if too much time has passed
	# Maybe doesn't need to be it's own method - see examples.rb
end

puts "Welcome to Goliath National Bank"
sign_in