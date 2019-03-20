class Account

	attr_accessor :customer, :balance
	attr_reader :acct_type, :acct_num

	def initialize(customer, balance, acct_type, acct_num)
		@customer = customer
		@balance = balance
		@acct_type = acct_type
		@acct_num = acct_num
	end

	def withdrawal(amount)
		@balance -= amount
	end

	def deposit(amount)
		@balance += amount
	end

	def acct_num
		@acct_num
	end

end

class Customer

	attr_accessor :firstname, :lastname

	def initialize(firstname, lastname, pin)
		@firstname = firstname
		@lastname = lastname
		@pin = pin
	end

	def fullname
		"#{@firstname} #{@lastname}"
	end

	def pin
		@pin
	end
end