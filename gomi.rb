# coding: utf-8
require "date"
require "slack"
require "yaml"

class Gomi
  def who
    person = @config["persons"].sample
    "<#{person}>"
  end

  def itsu(date)
    if date == Date.today
      "今日"
    elsif date == Date.today + 1
      "明日"
    else
      "#{date.month}月#{date.day}日"
    end
  end

  def gomi_type(date)
    gomitypes = @config["gomitypes"]
    keys = @config["gomitypes"].keys
    gomitypes[keys[date.wday]]
  end

  def notify_to_slack(date)
    return if gomi_type(date).nil?
    Slack.chat_postMessage text: text(date), username: "ゴミ男", channel: @config["channel"]
  end

  def text(value)
    text = "#{who} #{itsu(value)}は#{gomi_type(value)}ゴミの日だよ"
  end

  def init
    @config = YAML.load_file('conf/config.yml')
  end

  def gomi_info
    init
    Slack.configure do |config|
      config.token = @config["token"]
    end
    Slack.auth_test
    if DateTime.now.hour.to_i > 9
      value = Date.today + 1
    else
      value = Date.today
    end
    #say_text(value)
    notify_to_slack(value)
  end

end

Gomi.new.gomi_info
