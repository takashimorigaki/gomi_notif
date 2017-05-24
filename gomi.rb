# coding: utf-8
require "date"
require "slack"
require "yaml"

class Gomi
  def init
    @config = YAML.load_file('conf/config.yml')
  end

  def who
    person = @config["persons"].sample
    "<#{person}>"
  end

  def localed_date(date)
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
    wday_keys = @config["gomitypes"].keys
    gomitype = gomitypes[wday_keys[date.wday]]

    if gomitype["#{week_num(date)}week"].nil?
      gomitype["default"]
    else
      gomitype["#{week_num(date)}week"]
    end
  end

  def notify_to_slack(date)
    return if gomi_type(date).nil?
    Slack.chat_postMessage text: text(date), username: "ゴミ男", channel: @config["channel"]
  end

  def text(date)
    "#{who} #{localed_date(date)}は#{gomi_type(date)}ゴミの日だよ"
  end

  def gomi_info
    init
    Slack.configure do |config|
      config.token = @config["token"]
    end
    Slack.auth_test
    if DateTime.now.hour.to_i > 9
      date = Date.today + 1
    else
      date = Date.today
    end
    notify_to_slack(date)
  end

  def week_num(date)
    wday = (date.wday == 0) ? 6 : date.wday - 1
    (date.day - wday + 13) / 7
  end

  def test(date)
    init
    print("#{text(date)}\n")
  end

end

Gomi.new.gomi_info
