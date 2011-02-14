Gem::Specification.new do |s|
  s.name        = "formtastic_jquery_ui"
  s.version     = "0.0.4"
  s.author      = "Paul Smith"
  s.email       = "paul@elandesign.co.uk"
  s.homepage    = "http://github.com/elandesign/formtastic_jquery_ui"
  s.summary     = "Provides Formtastic input helpers for some jQuery UI widgets"

  s.files        = Dir["{lib,test,rails}/**/*", "[A-Z]*"]
  s.require_path = "lib"

  s.required_rubygems_version = ">= 1.3.4"
  
  s.add_dependency "formtastic", ">= 1.1.0"
  
end