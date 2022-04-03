require './main'
require "json"
require "tty-prompt"

describe 'check_password' do
    it 'check correct password' do
        user = { name: "Jim", password: "1234", goal: "1500", progress: 0 }
        expect { check_password(user, "1234") }.to output.to_stdout
    end
    it 'check inccorect password' do
        user = { name: "Jim", password: "1234", goal: "1500", progress: 0 }
        expect { check_password(user, "2234") }.to raise_error(InvalidPasswordError)
    end
end

describe 'reset_calorie_progress' do
    it 'should reset progress to zero' do
        user = { name: "Jim", password: "1234", goal: "1500", progress: 1400 }
        reset_calorie_progress(user)
        expect(user[:progress]).to eq 0
    end
    it 'should reset clear intake and workout activities' do
        user = { name: "Jim", password: "1234", goal: "1500", progress: 1400 }
        reset_calorie_progress(user)
        expect(user[:intakes]).to be_empty
        expect(user[:workouts]).to be_empty
    end
end