# Jekyll::Image::Resizer

Jekyll image resizer plugin. Resize images with simple command.

## Installation

Add this line to your application's Gemfile:

```ruby
group :jekyll_plugins do
  gem 'jekyll-image-resizer', git: 'git@github.com:kisakov/jekyll-image-resizer.git'
end
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install jekyll-image-resizer

And finaly add these to your _config.yml

```yml
image_width: 2048
image_small_width: 300
image_quality: 90
```

## Usage

    $ jekyll resize 2017-01-15-first-weekend # 1st argument is path
    $ jekyll resize 2017-01-15-first-weekend 300 90 # 1st argument is path, 2nd is image width and 3rd it's quality

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake false` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/jekyll-image-resizer.

