require File.dirname(__FILE__) + '/lib/animoto'

Gem::Specification.new do |s|
  s.name = "animoto"
  s.version = Animoto.version
  s.author = "Animoto"
  s.email = "theteam@animoto.com"
  s.files = ['README.md', *Dir.glob("./**/*.rb")]
  s.has_rdoc = true
  s.require_paths = ["lib"]
  s.homepage = "http://animoto.com"
  s.summary = "Client for working with the Animoto RESTful HTTP API"
  s.description = "The Animoto API is a RESTful web service that transforms images, videos, music, and text into amazing video presentations. The Animoto API Ruby Client provides a convenient Ruby interface for working with the Animoto RESTful HTTP API."
  s.add_runtime_dependency "json", ["> 0.0.0"]
end