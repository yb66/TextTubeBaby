source 'https://rubygems.org'

# Specify your gem's dependencies in TextTubeBaby.gemspec
gemspec


group :development do
  unless RUBY_ENGINE == 'jruby' || RUBY_ENGINE == "rbx"
    gem "pry"
    gem "pry-byebug"
  end
  gem "rake"
end

group :test do
	gem "rspec"
	gem "simplecov"
	gem "rspec-its"
	gem "rdiscount" # can't use this with JRuby... think about what to do.
end
