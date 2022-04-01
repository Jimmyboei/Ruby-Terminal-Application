require "json"
require "tty-prompt"
require "./methods"

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

# user login process
answer = prompt.ask("What is your name?")
if all_user_names.include? answer
    # set current_user to this user
    userdata.each do |i|
        if i[:name] == answer
            current_user = i
            # p current_user
        end
    end
    # password check
    begin
        if current_user[:password] == prompt.ask("Hi #{answer}, please enter your password")
            puts "Welcome back #{answer}!"
            puts "Your current progress is #{current_user[:progress]}/#{current_user[:goal]} calories"
        else
            raise "Wrong password! Please try again"
        end
    rescue => e
        puts e
        retry
    end
else
    newname = prompt.ask("New user? register a new user name:")
    newpassword = prompt.ask("Please enter a password:")
    newgoal = prompt.ask("What is your daily goal?")
    puts "Welcome #{newname}!"
    current_user = { name: newname, password: newpassword, goal: newgoal, progress: 0 }
    userdata << current_user
    File.write('userdata.json', JSON.pretty_generate(userdata))
end

menu_choice(current_user)

# write user data back to json file
File.write('userdata.json', JSON.pretty_generate(userdata))


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

