require "json"
require "tty-prompt"
require "./login_methods"
require "./menu_methods"
require "tty-table"

prompt = TTY::Prompt.new

# Class for user data in hash
class User
    attr_accessor :name, :password, :goal

    def initialize(hash)
        self.name = hash[:name]
        self.password = hash[:password]
        self.goal = hash[:goal]
    end
end

# get all saved user details
userdata = JSON.load_file('userdata.json', symbolize_names: true)

# create an array to store all user names for checkup
all_user_names = []
userdata.each do |user|
    all_user_names << user[:name]
end

# create a hash to store details of user using the app
current_user = {}

# existing user varification
input = prompt.ask("Welcome to the Daily Calorie Tracker, please enter your name:")
if all_user_names.include? input
    # get user details
    userdata.each do |i|
        if i[:name] == input
            current_user = i
            # p current_user
        end
    end
    # password check
    begin
        password = prompt.ask("Hi #{name}, please enter your password:")
        check_password(current_user, password)
    rescue InvalidPasswordError => e
        puts e.message
        retry
    end
else
    # new user sign up
    username = new_name_check(all_user_names)
    userdetails = user_registration
    current_user = username.merge!(userdetails)
    welcome_message(current_user)
    userdata << current_user
    File.write('userdata.json', JSON.pretty_generate(userdata))
end

press_anykey_to_continue
menu_choice(current_user)
save_and_exit(userdata)
