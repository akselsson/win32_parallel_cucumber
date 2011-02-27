# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

Gem::Specification.new do |s|
  s.name        = "win32-parallel_cucumber"
  s.version     = "0.0.1"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Patrik Akselsson"]
  s.email       = ["patrik.akselsson@gmail.com"]
  s.homepage    = "https://github.com/akselsson/win32_parallel_cucumber"
  s.summary     = "A simple parallel cucumber runner for windows"

  s.files        = Dir.glob("{bin,lib}/**/*")
  s.executables  = ['parallel_cucumber']
  s.require_path = 'lib'
end