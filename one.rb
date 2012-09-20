#!/usr/bin/env ruby
# coding: utf-8

require "mechanize"

class HatenaOne
  def initialize(user, password)
    @user     = user
    @password = password
    @agent    = Mechanize.new

    login
  end

  def login
    @agent.get("http://one.hatena.ne.jp/"){|page|
      page.form_with(:action => "/login"){|form|
        form.field_with(:id => "login-name"){|id| id.value = @user}
        form.password = @password
      }.submit
    }
  end

  def post(comment)
    @agent.get("http://one.hatena.ne.jp/o/timeline"){|one|
      one.form_with(:action => "http://h2.hatena.ne.jp/post.text"){|form|
        form.field_with(:id => "form-text-input"){|id| id.value = comment}
      }.submit
    }
  end
end
