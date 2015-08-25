require "mastermind/version"
require "fileutils"
require "colorize"
require "active_support/core_ext/string/inflections"
require "yaml"

module Mastermind
  # Your code goes here...
end

APP_ROOT = Pathname.new(File.expand_path('../../', __FILE__))
Dir[APP_ROOT.join('lib', 'mastermind', '*.rb')].each { |f| require f unless f.include? 'extension'}
