# Hi! This is just my 'trying it out' file. Not connected to the overall bank program.

# require 'io/console'

# print "Enter Password: "
# password = STDIN.noecho(&:gets).chomp
# puts "\n#{password}"

# ONE-LINE PROMPT AND INPUT
# def prompt(*args)
#     print(*args)
#     gets.chomp
# end

# name = prompt "Input name: "

# puts name


# TIMEOUT!
user_input = Thread.new do
  print "Enter something: "
  Thread.current[:value] = gets.chomp
end

timer = Thread.new { sleep 3; user_input.kill; puts }

user_input.join
if user_input[:value]
  puts "User entered #{user_input[:value]}"
else
  puts "Timer expired"
end