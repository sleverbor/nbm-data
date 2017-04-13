# Nbm::Data

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'nbm-data'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install nbm-data

## Usage

Run bin/nbm-data [-f, --format format] state1, state2, ... , staten

1. states -- be sure to use at least 3 letters from each state name.
2. format -- *csv* will list the name, population, households, income below poverty,
and median income.  This is the default format. *averages* will list the weighted average (according to
population percent of total population represented by the states listed) of
income below poverty.
