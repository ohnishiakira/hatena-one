#!/usr/bin/env ruby
# coding: utf-8

require "mechanize"

class HatenaOne
  def initialize(user, password)
    @user     = user
    @password = password
    @agent    = Mechanize.new

    @agent.follow_meta_refresh = true

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

  def timeline(count=20)
    @agent.page.search("#timeline li").map{|a|
      hatena_id = a["data-entry-author"]

      content = case a["class"]
      when /bookmark/
        [
          a.search(".summary").text,
          a.search("a.entry-link-title").text,
          a.search(".border-box a").first.attr("href")
        ].join(" ")
      when /blog_entry/, /diary/
        header = a.search(".header > a").first
        [
          header.text,
          header.attr("href")
        ].join(" ")
      when /haiku2_default_text/
        [
          a.search(".summary").text
        ].join
      when /nano_friendship_chunked/
        [
          a.search(".username").text,
          "さんとともだちになりました"
        ].join
      end

      [content].unshift(hatena_id).join(" : ")
    }
  end
end
