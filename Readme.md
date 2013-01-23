# Snoozer #

Snoozer is an extensible platform written in Ruby designed to emulate the 'snooze' features of the newly-launched Mailbox iOS app (http://mailboxapp.com).  The feature is designed to let users use email more like a to-do list.  Users can tag emails according to when they want the email to re-surface in their inbox.  I wanted to replicate this feature in Gmail without waiting for the app to launch (and I wanted to continue using Sparrow on my iPhone), so here's my attempt.

## Warnings ##

This software can potentially take destructive action on your email (like sending it to the trash!), so be very careful when using it.  Before sending important emails to your Snoozer labels, send some test emails to see if the software behaves as expected.

## Installation ##

```
git clone https://github.com/mattparmett/snoozer.git
cd snoozer
bundle install
heroku create
git push heroku master
heroku ps:scale web=0 worker=1 #make sure we have a worker process running, not a web (keeps the app free)
```

## Configuration ##

Immediately after installing Snoozer, you'll want to configure it to hook into your Gmail account:

	heroku config:add gmail_username=[gmail username] gmail_password=[gmail password]

Your login credentials are stored as envirnomental variables, so they're inaccessible outside of your Heroku instance of Snoozer.

## Usage ##

The action happens in the `bin` folder, in `snoozer.rb`.  You will want to edit this file to change your desired label names, search criteria, etc.  Let's take a look at the possible options:

```ruby
snoozer.unsnooze do
	# The label snoozer should look for messages in
  label                'Tomorrow'

  # The day on which this filter should operate
  day                  Date.today.strftime('%A').downcase

  # Operate on messages labeled before specified date
  labeled_before       Date.today

  # Operate on messages labeled after specified date
  labeled_after        Date.today - 4

  # Action to take on messages that match the above criteria
  action               'unread_to_inbox'
end
```

### Workflow

To make sure Snoozer works as intended, here is the expected email workflow:

1.	Receive email to inbox
2.	Open email, decide it should wait, and *move* to special label (i.e. remove from inbox and assign label)
3.	Later, Snoozer acts on the email.  For example, it may bring it back to the inbox and mark unread.
4.	Repeat.

## Actions ##

Snoozer lets users define custom actions which it can then apply to email in one of its special labels.  Plugins are ```.rb``` files located in `/lib/actions`.  All plugins located in that directory are available to be specified in the `action` parameter of a Snoozer block, like so:

```ruby
snoozer.unsnooze do
  label                'Test'
  day                  Date.today.strftime('%A').downcase
  labeled_before       Date.today + 1
  action               [action_name]
end
```

### The Action Template ###

Actions are essentially extensions of the Snoozer class, which makes them available to be used in the nice way described above.  To write an action, you need some knowledge of Ruby and the `gmail` gem.  The `unread_to_inbox` action included with Snoozer marks an email as unread and sends it back to the inbox, emulating the function of the Mailbox app; see that file for an example of an action.  Another simple action, `star`, could look like:

```ruby
class Snoozer
	def star
		read_label(@label).each do |email|
      email.star!
    end
  end
end
```

Actions have access to the messages in the label specified in the Snoozer block.  To iterate through these messages, use `read_label(@label).each { |email| }` like shown above.

## Acknowledgements ##

[Crony](https://github.com/thomasjachmann/crony) -- Digest is based on Crony, a lightweight, free alternative to Heroku's cron add-on developed by [Thomas Jachmann](https://github.com/thomasjachmann).

[Rufus-Scheduler](https://github.com/jmettraux/rufus-scheduler) -- Powers Crony's cron mechanism.

## License ##

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.