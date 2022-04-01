require "json"
require "tty-prompt"

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
end

def welcome_message
end

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
            exit_app
            break
        end
    end
end