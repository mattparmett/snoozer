class Snoozer
  def move_to_inbox
    @labels.each do |label|
      read_label(label).each do |email|
        email.move_to('Inbox', label)
      end
    end
  end
end