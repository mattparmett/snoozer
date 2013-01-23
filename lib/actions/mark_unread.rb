class Snoozer
  def mark_unread
    @labels.each do |label|
      read_label(label).each do |email|
        email.unread!
      end
    end
  end
end