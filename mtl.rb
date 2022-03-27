#!/usr/bin/env ruby

require 'thor'
require "pry"

class MyTaskList < Thor
  desc 'add', 'add task'
  def add(task)
    File.open('task_list.txt', 'a+') do |task_list|
      current = Time.now.strftime("%Y-%m-%d %H:%M")
      task_list.puts("[#{current}] #{task}")
    end
    puts 'add task'
  end

  desc 'list', 'view task list'
  def list
    File.foreach('./task_list.txt').with_index do |task, i|
      puts "#{i}: #{task}"
    end
  end
end

MyTaskList.start