# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mastermind/version'

Gem::Specification.new do |spec|
  spec.name          = "mastermind"
  spec.version       = Mastermind::VERSION
  spec.authors       = ["Oreoluwa Akinniranye"]
  spec.email         = ["oreoluwa.akinniranye@andela.com"]

  spec.summary       = %q{Play against the computer by guessing the colors it has stored. You will be amongst the top ten if you got it in fewer guesses and least time}
  spec.description   = %q{The mastermind game is a game of analysis and guesses. The idea is to guess the colors and the sequence that the computer has generated.}
  spec.homepage      = "https://github.com/andela-oakinniranye/mastermind"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport"
  spec.add_dependency "colorize"
  spec.add_dependency "humanize"

  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-nc"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-remote"
  spec.add_development_dependency "pry-nav"
  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
end
