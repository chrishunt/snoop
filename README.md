# Snoop
[![Travis CI](https://travis-ci.org/chrishunt/snoop.png)](https://travis-ci.org/chrishunt/snoop)
[![Coverage Status](https://coveralls.io/repos/chrishunt/snoop/badge.png?branch=master)](https://coveralls.io/r/chrishunt/snoop)
[![Code Climate](https://codeclimate.com/github/chrishunt/snoop.png)](https://codeclimate.com/github/chrishunt/snoop)

Snoop on content, be notified when it changes.

## Usage

Want to know when the next version of JRuby is released? Me too! Let's `Snoop`
the [JRuby homepage](http://jruby.org) and print to the terminal when a new
version has been posted. In this example, we'll check
[jruby.org](http://jruby.org) every 5 minutes for a new version.

```ruby
require 'snoop'

snoop = Snoop::HttpNotifier.new(
  url: 'http://jruby.org',
  css: '#latest_release strong'
)

snoop.notify while: -> { true }, delay: 300 do |version|
  puts "New JRuby Version! #{version}"
end
```

### Mac OS Notifications

`Snoop` works really well with Mac OS X notifications. Install
[terminal-notifier](https://github.com/alloy/terminal-notifier) and use it in
your notify callback.

```bash
$ gem install terminal-notifier
```

Let's send Mac OS X notifications when people start watching our video on
[Confreaks](http://www.confreaks.com). We'll use `Snoop` to check for updates
every 2 minutes and send a notification if we get more views. In this example,
the `Snoop` will run until the video has reached 2000 views, then stop.

```ruby
require 'snoop'

video = '2291-larubyconf2013-impressive-ruby-productivity-with-vim-and-tmux'

snoop = Snoop::HttpNotifier.new(
  url: "http://www.confreaks.com/videos/#{video}",
  css: '.video-rating'
)

view_count = 0

snoop.notify until: -> { view_count >= 2000 }, delay: 120 do |video_rating|
  current_view_count = video_rating.gsub(/\D/, '').to_i
  new_view_count     = current_view_count - view_count
  view_count         = current_view_count

  message = "#{current_view_count} views (#{new_view_count} new) on your video!"

  puts "Sending notification: #{message}"
  `terminal-notifier -message "#{message}"`
end
```

## Options

### CSS Selectors

Each `Snoop` requires a URL, but you can also provide a css selector if you're
only interested in part of the page's content. The css selector you provide is
handed directly to [Nokogiri](http://nokogiri.org), so the same syntax is
required.

```ruby
require 'snoop'

# Receive notifications if any part of the page changes
snoop = Snoop::HttpNotifier.new(
  url: 'http://jruby.org'
)

# Receive notifications if just the latest JRuby release changes
snoop = Snoop::HttpNotifier.new(
  url: 'http://jruby.org',
  css: '#latest_release strong'
)
```

### Delay and Count

If you'd like to have your `Snoop` check for new content more than once, you
can provided a `count`. Alternatively, you can use [Conditional
Snooping](#conditional-snooping).

The `count` option is most useful for timeboxing a `Snoop`.

```ruby
require 'snoop'
snoop = Snoop::HttpNotifier.new(url: 'http://jruby.org')

# Check JRuby for updates, every minute for 10 minutes
snoop.notify count: 10, delay: 60 do |content|
  puts content
end
```

### Conditional Snooping

By default, a `Snoop` will only check once and return immediately. This is almost
useless since we are interested in change over time. Conditional Snooping is
possible with the `while` and `until` arguments. It is almost *always*
recommended to provide a `delay` when using conditional Snooping unless you are
trying to [DDoS](http://en.wikipedia.org/wiki/Denial-of-service_attack)
someone.

Here's an example of a daemon `Snoop` that runs forever, checking the JRuby
homepage every minute for changes.

```ruby
require 'snoop'

snoop = Snoop::HttpNotifier.new(url: 'http://jruby.org')

snoop.notify while: -> { true }, delay: 60 do |content|
  puts content
end
```

Something else we might want to do is check our
[Twitter](https://twitter.com/chrishunt) follower count. Here's an example that
checks twitter every 3 minutes for changes. If the content changes, then we
print our new follower count to the terminal. When we've reached 500 followers,
the `Snoop` will stop checking.

```ruby
require 'snoop'

snoop = Snoop::HttpNotifier.new(
  url: 'https://twitter.com/chrishunt',
  css: '[data-element-term="follower_stats"]'
)

follower_count = 0

snoop.notify until: -> { follower_count >= 500 }, delay: 180 do |content|
  follower_count = content.gsub(/\D/, '').to_i
  puts "You have #{follower_count} followers!"
end
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'snoop'
```

And then execute:

```bash
$ bundle
```

Or install it yourself as:

```bash
$ gem install snoop
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Run the tests (`bundle exec rake spec`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request
