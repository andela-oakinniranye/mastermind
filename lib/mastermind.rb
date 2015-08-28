require "mastermind/version"
require "fileutils"
require "colorize"
require "active_support/core_ext/string/inflections"
require "yaml"
require 'humanize'
require 'singleton'

require 'mastermind/helper'


module Mastermind
  # Your code goes here...
end

# Dir.glob('./lib/*').each do |folder|
#   Dir.glob(folder +"/*.rb").each do |file|
#     require file unless file.include? 'extension'
#   end
# end
APP_ROOT = Pathname.new(File.expand_path('../../', __FILE__))
Dir[APP_ROOT.join('lib', 'mastermind', '*.rb')].each { |f| require f unless f.include? 'extension'}
Dir[APP_ROOT.join('lib', 'mastermind', 'datastore', '*.rb')].each { |f| require f}
Dir[APP_ROOT.join('lib', 'mastermind', 'extensions', '*.rb')].each { |f| require f}
