require 'gmail'
require 'date'

# Require actions
Dir[File.join(File.dirname(__FILE__), 'actions', '*.rb')].each {|file| require file }

module Gmail
  class Message
    # Move to given box and delete from others.  
    def move_to(name, from=nil)
      label(name, from)
      flag(:deleted)
      @mailbox.expunge
    end
    alias :move :move_to
  end
end

class Snoozer
  def self.setter(*method_names)
    method_names.each do |name|
      send :define_method, name do |data|
        instance_variable_set("@#{name}".to_sym, data)
      end
    end
  end

  setter :labels, :days, :labeled_after, :labeled_before, :actions

  def initialize(args = {})
    defaults = {gmail_username: ENV['gmail_username'],
                gmail_password: ENV['gmail_password']}
    defaults.merge!(args).each do |attr, val|
      instance_variable_set("@#{attr}", val) if defaults.has_key?(attr) && (not val.nil?)
    end
  end

  def unsnooze(&block)
    instance_eval(&block)
    if @days.map! { |day| day.downcase }.include? Date.today.strftime('%A').downcase
      @actions.each { |action| self.send(action.to_sym) }
    end
  end

  def search_args
    if @labeled_after && @labeled_before
      {after: @labeled_after, before: @labeled_before}
    elsif @labeled_after
      {after: @labeled_after}
    elsif @labeled_before
      {before: @labeled_before}
    else
      {}
    end
  end

  def read_label(label)
    Gmail.connect(@gmail_username, @gmail_password) do |gmail|
      return gmail.label(label).mails(search_args)
    end
   end
end