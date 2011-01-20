module FormtasticJQueryUI
  module Autocomplete
  
    def autocomplete_input(method, options)
      html_options = options.delete(:input_html) || {}
      options = set_include_blank(options)
      html_options[:multiple] = html_options[:multiple] || options.delete(:multiple)
      html_options.delete(:multiple) if html_options[:multiple].nil?
      
      autocomplete_options = options.delete(:autocomplete) || {}
      autocomplete_option_minLength = autocomplete_options[:minLength] || 2
      autocomplete_option_minLength_js =  "minLength: #{autocomplete_option_minLength},"

      html = ""
      reflection = self.reflection_for(method)
      input_name = "autocomplete_for_#{sanitized_object_name}_#{method}"
      param_name = options[:param_name] || 'term'
      url = options[:url] || ''
      
      if reflection && [:has_many, :has_and_belongs_to_many].include?(reflection.macro)
        selections_name = generate_html_id(method, 'selections')
        selection_name = "#{sanitized_object_name}[#{method.to_s.singularize}_ids][]"
        html << template.content_tag(:ul, object.send(method).map { |i| template.content_tag(:li, "<input type=\"hidden\" name=\"#{selection_name}\" value=\"#{i.id}\" />#{i.to_label} <a href=\"#\" onclick=\"$(this).closest('li').remove();\">Remove</a>") }.join(''), :id => selections_name)
        html << template.tag(:input, :type => 'hidden', :name => selection_name, :value => '')
        html << template.text_field_tag(input_name)
        html << template.content_tag(:script, :type => 'text/javascript') do
          <<-EOT
  $('##{input_name}').autocomplete({
    source: function(request, response) {
      $.ajax({
        url: '#{url}',
        dataType: 'json',
        data: {
          search: { #{param_name}: request.term }
        },
        success: function(data) {
          response(data);
        }
      });
    },
    #{autocomplete_option_minLength_js}
    select: function(event, selection) {
      if($('##{selections_name} input[value=' + selection.item.value + ']').length == 0)
        $('##{selections_name}').append('<li><input type="hidden" name="#{selection_name}" value="' + selection.item.value + '" />' + selection.item.label + ' <a href="#" onclick="$(this).closest(\\'li\\').remove();">Remove</a></li>');
      $('##{input_name}').val('');
      return false;
    },
    focus: function(event, ui) { return false; }
  });
EOT
        end
      elsif (reflection && [:belongs_to].include?(reflection.macro)) || reflection.nil?
        hidden_field_name = reflection.try(:primary_key_name) || "#{method}_id"
        html << self.hidden_field(hidden_field_name)
        html << template.text_field_tag(input_name, object.send(method).try(detect_label_method([object.send(method)])))
        html << template.content_tag(:script, :type => 'text/javascript') do
          <<-EOT
  $('##{input_name}').autocomplete({
    source: function(request, response) {
      $.ajax({
        url: '#{url}',
        dataType: 'json',
        data: {
          search: { #{param_name}: request.term }
        },
        success: function(data) {
          response(data);
        }
      });
    },
    #{autocomplete_option_minLength_js}
    select: function(event, selection) {
      $('##{sanitized_object_name}_#{hidden_field_name}').val(selection.item.value);
      $('##{input_name}').val(selection.item.label);
      return false;
    },
    focus: function(event, ui) { return false; }
  }); 
  $('##{input_name}').blur(function(event){
    if($(this).val() == '')
      $('##{sanitized_object_name}_#{hidden_field_name}').val('');
  })   
EOT
        end
      end
    
      template.content_tag(:label, localized_string(method, options[:label].is_a?(::String) ? options[:label] : nil, :label) || humanized_attribute_name(method), :for => input_name) << Formtastic::Util.html_safe(html)
    end
    
  end
end