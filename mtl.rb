#!/usr/bin/env ruby

require 'thor'

# Mtl(MyTaskList)
class Mtl < Thor
  MTL_TASK_LIST_FILE_PATH = ENV['MTL_TASK_LIST_FILE_PATH']
  default_command :list

  desc 'add', 'add task'
  def add(task)
    File.open(MTL_TASK_LIST_FILE_PATH, 'a+') do |task_list|
      current_time = Time.now.strftime('%Y-%m-%d %H:%M')
      task_list.puts("[#{current_time}] #{task}")
      puts 'succeeded!'
      task_list.seek(0)
      puts ''
      puts task_list.read
    end
  end

  desc 'rm', 'remove task'
  def rm(index)
    new_task_list = File.read(MTL_TASK_LIST_FILE_PATH)
                        .split(/\n/)
                        .reject.with_index { |_task, i| i == index.to_i }
                        .join("\n")

    File.open(MTL_TASK_LIST_FILE_PATH, 'w') do |task_list|
      task_list.puts(new_task_list)
    end
    puts new_task_list
  end

  desc 'list', 'view task list'
  def list
    File.foreach(MTL_TASK_LIST_FILE_PATH).with_index do |task, i|
      puts "#{i}: #{task}"
    end
  end
end

Mtl.start
