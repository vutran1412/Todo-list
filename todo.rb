require_relative "task.rb"

module Menu

    def menu
        puts "Please choose from the following list"
        puts "1.\tAdd"
        puts "2.\tShow"
        puts "3.\tDelete"
        puts "4.\tUpdate"
        puts "5.\tWrite to File"
        puts "6.\tRead From File"
        puts "7.\tToggle Status"
        puts "Q.\tQuit"
    end 

    def show
        menu
    end
end

module Promptable
    
    def prompt(message = "What would you like to do?", symbol = ":> ")
        print message
        print symbol
        gets.chomp
    end

end

class List

    attr_reader :tasks

    def initialize
        @tasks = []
    end

    def add_task(task)
        unless task.to_s.chomp.empty?
            @tasks << task
        end
    end

    def show
        @tasks.map.with_index {|task, idx| "#{idx + 1}) #{task}"}
    end

    def delete(task_number)
        @tasks.delete_at(task_number - 1)
    end

    def update(task_number, task)
        tasks[task_number - 1] = task
    end

    def toggle(task_number)
        tasks[task_number - 1].toggle_status
    end

    def write_to_file(filename)
        IO.write(filename, @tasks.map(&:to_machine).join("\n"))
    end

    def read_from_file(filename)
        IO.readlines(filename).each do |line|
            status, *description = line.split(":")
            status = status.include?("X")
            add_task(Task.new(description.join(":").strip, status))
        end
    end
end

if __FILE__ == $PROGRAM_NAME
    include Menu
    include Promptable
    my_list = List.new
    puts "Hello, welcome to the Todo list program"
        until ['q'].include?(user_input=prompt(show).downcase)
            case user_input
                when "1" then my_list.add_task(Task.new(prompt("What task would you like to add?")))
                when "2" then puts my_list.show
                when "3" then my_list.delete(prompt("Which task to delete?").to_i)
                when "4" then my_list.update(prompt("Which task to update?").to_i, Task.new(prompt("Task description?")))
                when "5" then my_list.write_to_file(prompt("What is the file name to write to?"))
                when "6" 
                    begin
                        my_list.read_from_file(prompt("What is the file name to read from?"))
                    rescue => exception
                        puts "File name was not found, please verify file name and path"
                    end
                when "7" 
                    puts my_list.show
                    my_list.toggle(prompt("Which task do you want to toggle status for?").to_i)
                else puts "Sorry, I do not understand"
            end 
        end
    puts "Thanks for using the menu"
end