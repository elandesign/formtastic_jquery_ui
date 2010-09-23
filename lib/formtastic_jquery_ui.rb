if Object.const_defined?("Formtastic")
  
  require 'formtastic_jquery_ui/datepicker.rb'
  Formtastic::SemanticFormBuilder.send(:include, FormtasticJQueryUI::Datepicker)
  
  require 'formtastic_jquery_ui/autocomplete.rb'
  Formtastic::SemanticFormBuilder.send(:include, FormtasticJQueryUI::Autocomplete)
  
end