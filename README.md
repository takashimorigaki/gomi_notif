# gomi_notif

## Setup
1. Gem install `$ bundle install` or `$ bundle install --path vendor/bundle`
2. Create YOUR_SLACK_TOKEN from https://api.slack.com/custom-integrations/legacy-tokens
3. Add YOUR_SLACK_TOKEN `$ vi gomi.rb`
```
Slack.configure do |config|
  config.token = "YOUR_SLACK_TOKEN"
end
```
4. Edit YOUR_NAME and YOUR_FRIEND'S_NAME `$ vi gomi.rb`
```
def who
  persons = ["@YOUR_NAME", "@YOUR_FRIEND'S_NAME1", "@YOUR_FRIEND'S_NAME2"]
  person = persons.sample 
  "<#{person}>"
end
```
5. Edit gomi_type
```
def gomi_type(value)
  gomitypes = [["sunday", ""],["monday", "燃える"], ["tuesday", "ペットボトル"], ["wednesday", "資源"], ["thursday", "燃える"], ["friday", "不燃"], ["saturday", ""]]
  gomitypes[value.wday][1]
end
```
6. Edit YOUR_SLACK_CHANNEL you wanna send message
```
def notify_to_slack(value)
  return if gomi_type(value).empty?
  Slack.chat_postMessage text: text(value), channel: "#YOUR_SLACK_CHANNEL"
end
```
6. Run test `$ ruby gomi.rb` or `$ bundle exec ruby gomi.rb` and you get gomi_info_message on slack
