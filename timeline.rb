#!/usr/bin/env ruby
# coding: utf-8

require "highline"
require "./one"

hl = HighLine.new

user     = hl.ask("id: ")
password = hl.ask("password: ") {|q| q.echo = '*'}

one = HatenaOne.new(user, password)
puts one.timeline
