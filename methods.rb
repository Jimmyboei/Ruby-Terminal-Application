require "json"
require "tty-prompt"

# custom exception for password check
class InvalidPasswordError < StandardError
    def message
        return "Wrong password! Please try again"
    end
end

# check password of current user
def check_password(user, password)
    raise InvalidPasswordError unless user[:password] == password

    puts "Welcome back #{user[:name]}!"
    puts "Your current progress is #{user[:progress]}/#{user[:goal]}calories"
end

# create a new user
def new_user_registration
    prompt = TTY::Prompt.new
    new_user = prompt.collect do
        key(:name).ask("Please enter a user name:") do |q|
            q.required(true, "user name cannot be empty")
        end

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

# record each food intake from user input
def intake_log(user, food, calorie)
    user[:intakes][food] = calorie
end

# record each workout from user input
def workout_log(user, workout, calorie)
    user[:intakes][workout] = calorie
end

# methods for menu options
def food_intake(user)
    prompt = TTY::Prompt.new
    loop do
        food_name = prompt.ask("Please enter the food name:") do |q|
        q.required(true, "Food name cannot be empty")
        end
        food_calorie = prompt.ask("How many calories in your food?", convert: :int)
        user[:progress] += food_calorie
        intake_log(user, food_name, food_calorie)
        puts "Intake added!"
        puts "Today you have #{user[:progress]}/#{user[:goal]} calories so far"
        answer2 = prompt.yes?("Do you want to add more intake?")
        break unless answer2
    end
end

def workout(user)
    prompt = TTY::Prompt.new
    loop do
        answer = prompt.ask("How many calories did you burn in your workout?", convert: :int)
        user[:progress] -= answer
        puts "workout added"
        puts "Today you have #{user[:progress]}/#{user[:goal]} calories so far"
        answer2 = prompt.yes?("Do you want to add more workout?")
        break unless answer2
    end
end

def adjust_goal(user)
    prompt = TTY::Prompt.new
    puts "Your current goal is #{user[:goal]} calories"
    answer = prompt.ask("Please enter your new daily calorie goal:") do |q|
        q.validate(/^[1-9]\d*$/)
        q.messages[:valid?] = "Please enter only number greater than zero"
    end
    user[:goal] = answer.to_i
    puts "Daily goal adjusted, your new goal is #{answer} calories"
    prompt.keypress("Press anykey to continue")
end

def save_and_exit(data)
    File.write('userdata.json', JSON.pretty_generate(data))
    puts "Thanks for using Daily Calories Tracker! See you later!"
end

# def welcome_message(username, usergoal)
#     puts "Welcome back #{username}!"
# end

# def save_data(user, allusers)
#     allusers << user
#     File.write('userdata.json', JSON.pretty_generate(allusers))
# end

def menu_choice(user)
    prompt = TTY::Prompt.new
    loop do
        choices = ["Add food intake", "Add workouts", "Adjust goals", "Exit"]
        selected = prompt.select("Please select from following options", choices, cycle: true)
        case selected
        when choices[0]
            food_intake(user)
        when choices[1]
            workout(user)
        when choices[2]
            adjust_goal(user)
        when choices[3]
            break
        end
    end
end
