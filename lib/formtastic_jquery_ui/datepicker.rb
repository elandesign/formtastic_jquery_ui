module FormtasticJQueryUI
  module Datepicker
    
    def datepicker_input(method, options)
      html_options = options.delete(:input_html) || {}
      html_options = default_string_options(method, type).merge(html_options) if [:numeric, :string, :password, :text].include?(type)

      self.label(method, options_for_label(options)) <<
      self.send(:text_field, method, html_options) <<
      template.content_tag(:script, :type => 'text/javascript') do
        <<-EOT
  $('##{sanitized_object_name}_#{method}').datepicker({dateFormat: 'yy-mm-dd'});   
EOT
      end
    end
    
  end
end

