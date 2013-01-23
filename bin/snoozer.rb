require File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'snoozerlib.rb'))

# Set a shortcut for today's date
TODAY = Date.today

# Create a snoozer object
snoozer = Snoozer.new(gmail_username: ENV['gmail_username'], gmail_password: ENV['gmail_password'])

# If it is 10AM (between 10 and 10:05, to account for startup/error time)
if Time.now > Time.mktime(TODAY.year, TODAY.month, TODAY.day, 10, 0, 0) && \
   Time.now < Time.mktime(TODAY.year, TODAY.month, TODAY.day, 10, 5, 0)

  # For all messages in the tomorrow label that were moved to that label
  # before today, mark them unread and move them to the inbox
  snoozer.unsnooze do
    labels               ['Tomorrow']
    days                 [Date.today.strftime('%A').downcase]
    labeled_before       Date.today
    actions              [:mark_unread, :move_to_inbox]
  end

  # If today is Saturday:
  # For all messages in the this weekend label that were moved to that label
  # in the past week, mark them unread and move them to the inbox
  snoozer.unsnooze do
    labels              ['This Weekend']
    days                ['saturday']
    labeled_after       Date.today - 7
    actions             [:mark_unread, :move_to_inbox]
  end

  # If today is Monday:
  # For all messages in the next week label that were moved to that label
  # in the past week, mark them unread and move them to the inbox
  snoozer.unsnooze do
    labels              ['Next Week']
    days                ['monday']
    labeled_after       Date.today - 7
    actions             [:mark_unread, :move_to_inbox]
  end
end

# If it is 8PM (between 8 and 8:05 to account for error)
if Time.now > Time.mktime(TODAY.year, TODAY.month, TODAY.day, 20, 0, 0) && \
   Time.now < Time.mktime(TODAY.year, TODAY.month, TODAY.day, 20, 5, 0)
  # For all messages in the later today label that were moved to that label
  # today, mark them unread and move them to the inbox
  snoozer.unsnooze do
    labels              ['Later Today']
    days                [Date.today.strftime('%A').downcase]
    labeled_after       Date.today - 1
    actions             [:mark_unread, :move_to_inbox]
  end
end