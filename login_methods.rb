require "json"
require "tty-prompt"
require "tty-table"

def help_info
    puts "Welcome to the Daily Calorie Tracker"
    puts "In here you can set your calorie goals and track your progress"

end

# custom exception for password check
class InvalidPasswordError < StandardError
    def message
        return "Wrong password! Please try again"
    end
end

# custom exception for existing user name
class ExistingNameError < StandardError
    def message
        return "User name already exists, please enter a different name"
    end
end

# pull all user names from json file
# def read_from_file(file)
#     userdata = JSON.load_file(file, symbolize_names: true)
#     details = []
#     userdata.each do |i|
#         details << i[:name]
#     end
#     return details
# end

# check password of current user
def check_password(user, password)
    raise InvalidPasswordError unless user[:password] == password

    puts "Welcome back #{user[:name]}!"
end

# check if the new user name already exists
def new_name_check(allnames)
    prompt = TTY::Prompt.new
    puts "User name cannot be found"
    begin
        new_name = prompt.ask("Please sign up and store your details by entering your name:") do |q|
            q.required(true, "user name cannot be empty")
        end
        raise ExistingNameError if allnames.include? new_name
    rescue ExistingNameError => e
        puts e.message
        retry
    end
    username = { name: new_name }
    return username
end

# create a new user
def user_registration
    prompt = TTY::Prompt.new
    new_user = prompt.collect do
        key(:password).ask("Please enter a password:") do |q|
            q.required(true, "Password cannot be empty")
        end

        key(:goal).ask("What is your daily calorie goal?") do |q|
        q.validate(/^[1-9]\d*$/)
        q.messages[:valid?] = "Please enter only number greater than zero"
        end
    end
    new_user[:progress] = 0
    new_user[:intakes] = {}
    new_user[:workouts] = {}
    return new_user
end

def welcome_message(user)
    puts "Sign up succesful!"
    puts "Welcome to the Daily Calorie Tracker #{user[:name]}! "
    puts "Keep an eye for your calories intake and enjoy a healthier life!"
end

# let user to stay on current page and continue by pressing any keys
def press_anykey_to_continue
    prompt = TTY::Prompt.new
    prompt.keypress("Press anykey to continue")
end
