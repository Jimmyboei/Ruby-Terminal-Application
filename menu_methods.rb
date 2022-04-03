require "json"
require "tty-prompt"
require "tty-table"
require "./login_methods"

# record each food intake from user input
def intake_log(user, food, calorie)
    user[:intakes][food] = calorie
end

# record each workout from user input
def workout_log(user, workout, calorie)
    user[:workouts][workout] = calorie
end

# user input for calories intake and this will increase the daily progress
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
        add_more_intake = prompt.yes?("Do you want to add more intake?")
        break unless add_more_intake
    end
end

# user input for calories burned and this will reduce the daily progress
def workout(user)
    prompt = TTY::Prompt.new
    loop do
        workout_name = prompt.ask("Please enter the workout name:") do |q|
        q.required(true, "Workout name cannot be empty")
        end
        workout_calorie = prompt.ask("How many calories did you burn in your workout?", convert: :int)
        user[:progress] -= workout_calorie
        workout_log(user, workout_name, workout_calorie)
        puts "workout added"
        puts "Today you have #{user[:progress]}/#{user[:goal]} calories so far"
        add_more_workout = prompt.yes?("Do you want to add more workout?")
        break unless add_more_workout
    end
end

# create all user activities in a table
def display_activity_table(user_activity, header1, header2)
    table = TTY::Table[[header1, header2]]
    user_activity.each do |name, calorie|
        table << [name, calorie]
    end
    puts table.render(:ascii)
end

# reset the user's calorie progress to zero
def reset_calorie_progress(user)
    user[:progress] = 0
    user[:intakes] = {}
    user[:workouts] = {}
    puts "Your current calorie progress has been reset"
    press_anykey_to_continue
end

# allow users to adjust their daily calorie goal
def adjust_goal(user)
    prompt = TTY::Prompt.new
    puts "Your current goal is #{user[:goal]} calories"
    new_goal = prompt.ask("Please enter your new daily calorie goal:") do |q|
        q.validate(/^[1-9]\d*$/)
        q.messages[:valid?] = "Please enter only number greater than zero"
    end
    user[:goal] = new_goal.to_i
    puts "Daily goal adjusted, your new goal is #{new_goal} calories"
    press_anykey_to_continue
end

# main menu with all options
def menu_choice(user)
    prompt = TTY::Prompt.new
    loop do
        system 'clear'
        puts "Hi #{user[:name]}, your current progress is #{user[:progress]}/#{user[:goal]}calories"
        choices = ["Add Food Intake", "Add Workout", "View Activities", "Reset Current Progress", "Adjust Goal", "Exit"]
        selected = prompt.select("Please select from following options", choices, cycle: true)
        case selected
        when choices[0]
            food_intake(user)
        when choices[1]
            workout(user)
        when choices[2]
            system "clear"
            display_activity_table(user[:intakes], "Food", "Calories Intake")
            display_activity_table(user[:workouts], "Workout", "Calories Burned")
            press_anykey_to_continue
        when choices[3]
            reset_calorie_progress(user)
        when choices[4]
            adjust_goal(user)
        when choices[5]
            break
        end
    end
end

# write user data back to json file
def save_and_exit(data)
    File.write('userdata.json', JSON.pretty_generate(data))
    puts "Thanks for using Daily Calories Tracker! See you later!"
end
