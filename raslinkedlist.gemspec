$:.push File.expand_path("../lib", __FILE__)
require 'raslinkedlist'

Gem::Specification.new do |s|
	s.name        = 'raslinkedlist'
	s.version     = RasLinkedList::VERSION
	s.date        = '2013-05-28'
	s.summary     = "Basic linked list structure"
	s.description = "A test gem that also contains a very simple linked list structure that was used for Ruby learning purposes."
	s.authors     = ["Ryan Sciampacone"]
	s.email       = 'rsciampacone@gmail.com'
	s.homepage    = 'http://github.com/rsciampacone/randomrubyhacking'
    
	s.files         = `git ls-files`.split("\n")
    s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
    s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
    s.require_paths = ["lib"]
end
