require "json"
require "tty-prompt"

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

# methods for menu options
def food_intake(user)
    prompt = TTY::Prompt.new
    loop do
        answer = prompt.ask("How many calories in your food?", convert: :int)
        user[:progress] += answer
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
    answer = prompt.ask("Please enter your new daily goal", convert: :int)
    user[:goal] = answer
    puts "Daily goal adjusted, your new goal is #{answer} calories"
    answer2 = prompt.yes?("Do you want more actions?")
    exit_app unless answer2
end

def exit_app
    puts "Thanks for using Daily Calories Tracker! See you later!"
    exit
end

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
            exit_app
        end
    end
end

# get all saved user details
userdata = JSON.load_file('userdata.json', symbolize_names: true)

# p userdata
# p userdata[0]
# p userdata[0][:name]

# set an array to store all user names for checkup
all_user_names = []
userdata.each do |i|
    all_user_names << i[:name]
end

# set a hash to store details of user using the app
current_user = {}

answer = prompt.ask("What is your name?")

if all_user_names.include? answer
    # set current_user to this user
    userdata.each do |i|
        if i[:name] == answer
            current_user = i
            p current_user
        end
    end
    # password check
    begin
        answer2 = prompt.ask("Hi #{answer}, please enter your password")
        if answer2 == current_user[:password]
            puts "Welcome back!"
        else
            raise "Wrong password! Please try again"
        end
    rescue => e
        puts e
        retry
    end
else
    newname = prompt.ask("New user? register a new user name")
    newpassword = prompt.ask("Please enter a password")
    newgoal = prompt.ask("What is your daily goal?")
    puts "Welcome #{newname}!"
    current_user = { name: newname, password: newpassword, goal: newgoal, progress: 0 }
    userdata << current_user
    File.write('userdata.json', JSON.pretty_generate(userdata))
end

menu_choice(current_user)

# original way for menu options without using method
# loop do
#     choices = ["Add food intake", "Add workouts", "Adjust goals", "Exit"]
#     selected = prompt.select("Please select from following options", choices, cycle: true)
#     case selected
#     when choices[0]
#         loop do
#             answer = prompt.ask("How many calories in your food?", convert: :int)
#             current_user[:progress] += answer
#             puts "Intake added!"
#             puts "Today you have #{current_user[:progress]}/#{current_user[:goal]} calories so far"
#             answer2 = prompt.yes?("Do you want to add more intake?")
#             break unless answer2
#         end
#     when choices[1]
#         loop do
#             answer = prompt.ask("How many calories did you burn in your workout?", convert: :int)
#             current_user[:progress] -= answer
#             puts "workout added"
#             puts "Today you have #{current_user[:progress]}/#{current_user[:goal]} calories so far"
#             answer2 = prompt.yes?("Do you want to add more workout?")
#             break unless answer2
#         end
#     when choices[2]
#         puts "Your current goal is #{current_user[:goal]} calories"
#         answer = prompt.ask("Please enter your new daily goal", convert: :int)
#         current_user[:goal] = answer
#         puts "Daily goal adjusted, your new goal is #{answer} calories"
#         answer2 = prompt.yes?("Do you want more actions?")
#         break unless answer2
#     when choices[3]
#         puts "Thanks for using Daily Calories Tracker! See you later!"
#         exit
#     end
# end

