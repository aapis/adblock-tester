require './lib/version'

Gem::Specification.new do |s|
  s.name          = 'amiblocked'
  s.version       = AmIBlocked::VERSION
  s.date          = Date.today
  s.summary       = 'Simple Adblock list testing'
  s.description   = 'Check if your service blocked by adblockers'
  s.authors       = ['Ryan Priebe']
  s.email         = 'hello@ryanpriebe.com'
  s.files         = `git ls-files`.split($OUTPUT_RECORD_SEPARATOR)
  s.homepage      = 'http://rubygems.org/gems/amiblocked'
  s.license       = 'MIT'
  s.executables   = 'amiblocked'
end
