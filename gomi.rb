require "date"
require "slack"

Slack.configure do |config|
  config.token = "YOUR_SLACK_TOKEN"
end

Slack.auth_test

class Gomi
  def who
    persons = ["@YOUR_NAME", "@YOUR_FRIEND'S_NAME1", "@YOUR_FRIEND'S_NAME2"]
    person = persons.sample
    "<#{person}>"
  end

  def itsu(value)
    if value == Date.today
      "今日"
    elsif value == Date.today + 1
      "明日"
    else
      "#{value.month}月#{value.day}日"
    end
  end

  def gomi_type(value)
    gomitypes = [["sunday", ""],["monday", "燃える"], ["tuesday", ""], ["wednesday", "ビン・缶・ペットボトル・段ボール"], ["thursday", "燃える"], ["friday", "不燃"], ["saturday", ""]]
    gomitypes[value.wday][1]
  end

  def notify_to_slack(value)
    return if gomi_type(value).empty?
    Slack.chat_postMessage text: text(value), username: "ゴミ男", channel: "#YOUR_SLACK_CHANNEL"
  end

  def text(value)
    text = "#{who} #{itsu(value)}は#{gomi_type(value)}ゴミの日だよ"
  end

  def gomi_info
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
