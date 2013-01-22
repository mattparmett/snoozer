class Snoozer
  def unread_to_inbox
    read_label(@label).each do |email|
      puts email.subject
      email.unread!
      email.move_to('Inbox', @label)
    end
  end
end