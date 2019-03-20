# Hi! This is just my 'trying it out' file. Not connected to the overall bank program.

# require 'io/console'

# print "Enter Password: "
# password = STDIN.noecho(&:gets).chomp
# puts "\n#{password}"

# ONE-LINE PROMPT AND INPUT
# def prompt(*args)
#   print(*args)
#   gets.chomp
# end

# number = (prompt "Give me a number: ").to_i

# puts number.class


# TIMEOUT!
# user_input = Thread.new do
#   print "Enter something: "
#   Thread.current[:value] = gets.chomp
# end

# timer = Thread.new { sleep 3; user_input.kill; puts }

# user_input.join
# if user_input[:value]
#   puts "User entered #{user_input[:value]}"
# else
#   puts "Timer expired"
# end