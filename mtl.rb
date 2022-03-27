#!/usr/bin/env ruby

require 'thor'
require 'pry'

# Mtl(MyTaskList)
class Mtl < Thor
  MTL_TASK_LIST_FILE_PATH = ENV['MTL_TASK_LIST_FILE_PATH']
  default_command :list

  desc 'add', 'add task'
  def add(task)
    result = TaskListFileClient.add(task)
    show_operation_succeeded_result(result)
  end

  desc 'rm', 'remove task'
  def rm(index)
    result = TaskListFileClient.remove(index)
    show_operation_succeeded_result(result)
  end

  desc 'list', 'view task list'
  def list
    puts TaskListFileClient.list
  end

  private

  def show_operation_succeeded_result(result)
    puts <<~RUBY
      succeeded!

      #{result}
    RUBY
  end
end

class TaskListFileClient
  MTL_TASK_LIST_FILE_PATH = ENV['MTL_TASK_LIST_FILE_PATH']

  class << self
    def add(task)
      current_time = Time.now.strftime('%Y-%m-%d %H:%M')

      File.open(MTL_TASK_LIST_FILE_PATH, 'a+') do |task_list|
        task_list.puts("[#{current_time}] #{task}")

        task_list.seek(0)
        generate_task_list_view(task_list.read)
      end
    end

    def remove(index)
      new_task_list =
        File.read(MTL_TASK_LIST_FILE_PATH)
            .split(/\n/)
            .reject.with_index { |_task, i| i == index.to_i }
            .join("\n")

      File.open(MTL_TASK_LIST_FILE_PATH, 'w') do |task_list|
        task_list.puts(new_task_list)
      end

      new_task_list
    end

    def list
      generate_task_list_view(File.read(MTL_TASK_LIST_FILE_PATH))
    end

    private

    def generate_task_list_view(list)
      list.split(/\n/)
          .map.with_index { |task, i| "#{i}: #{task}" }
          .join("\n")
    end
  end
end

Mtl.start
