class Snoozer
  def unread_to_inbox
    read_label(@label).each do |email|
      email.unread!
      email.move_to('Inbox', @label)
    end
  end
end