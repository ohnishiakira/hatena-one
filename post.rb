#!/usr/bin/env ruby
# coding: utf-8

require "highline"
require "./one"

hl = HighLine.new

user     = hl.ask("id: ")
password = hl.ask("password: ") {|q| q.echo = '*'}
comment  = hl.ask("comment: ")

one = HatenaOne.new(user, password)
one.post(comment)
