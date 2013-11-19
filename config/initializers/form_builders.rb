class ActionView::Helpers::FormBuilder
  
  def date_field_control(object, attribute, label_options = {}, field_options = {}, control_options = {})
    field_options[:class] = 'datepicker'
    field_options[:autocomplete] = 'off'
    field = self.text_field(attribute, field_options)
    input_control(object, attribute, label_options, field, control_options)
  end
  
  def tag_field_control(object, attribute, label_options = {}, field_options = {}, control_options = {})
    field_options['data-pre'] = object.send(attribute)
    field_options[:class] = 'tag-tokens'
    field_options['data-limit'] = field_options[:limit] unless field_options[:limit].nil?
    control_options[:after] = "<p class=\"hint\">Please enter up to #{field_options[:limit]} tags</p>" unless field_options[:limit].nil?
    field = self.text_field(attribute, field_options)
    input_control(object, attribute, label_options, field, control_options)
  end

  def text_field_control(object, attribute, label_options = {}, field_options = {}, control_options = {})
    field = self.text_field(attribute, field_options)
    input_control(object, attribute, label_options, field, control_options)
  end

  def email_field_control(object, attribute, label_options = {}, field_options = {}, control_options = {})
    field = self.email_field(attribute, field_options)
    input_control(object, attribute, label_options, field, control_options)
  end

  def url_field_control(object, attribute, label_options = {}, field_options = {}, control_options = {})
    field = self.url_field(attribute, field_options)
    input_control(object, attribute, label_options, field, control_options)
  end

  def phone_field_control(object, attribute, label_options = {}, field_options = {}, control_options = {})
    field = self.phone_field(attribute, field_options)
    input_control(object, attribute, label_options, field, control_options)
  end

  def password_field_control(object, attribute, label_options = {}, field_options = {}, control_options = {})
    field = self.password_field(attribute, field_options)
    input_control(object, attribute, label_options, field, control_options)
  end

  def text_area_control(object, attribute, label_options = {}, field_options = {}, control_options = {})
    if control_options.extract!(:mce)[:mce]
      control_options[:after] = '<span class="togglemce">Toggle rich-text</span>'
      field_options[:class] = "mceEditor"
    end
    field = self.text_area(attribute, field_options)
    input_control(object, attribute, label_options, field, control_options)
  end

  def select_control(object, attribute, label_options = {}, field_options = {}, control_options = {})
    options = field_options.extract!(:options)[:options]
    field = self.select(attribute, options, field_options)
    input_control(object, attribute, label_options, field, control_options)
  end

  def file_field_control(object, attribute, label_options = {}, field_options = {}, control_options = {})
    field = self.file_field(attribute, field_options)
    input_control(object, attribute, label_options, field, control_options)
  end
  
  def permalink_field_control(object, attribute, label_options = {}, field_options = {}, control_options = {})
    control_options[:before] = '<div class="permalink '+((object.send(attribute).blank?) ? '' : ' exists')+'">'
    if object.errors[attribute].empty?
      unless object.send(attribute).blank?
        control_options[:before] += '<div class="permalink-show">'
        control_options[:before] += control_options[:prefix] +'/' + object.send(attribute)
        control_options[:before] += '<span class="unlock">change</span></div>'
      end
      control_options[:before] += '<div class="permalink-edit">'
      field = control_options[:prefix] +'/' + self.text_field(attribute, control_options)
      control_options[:after] = '</div>'
    else
      field = control_options[:prefix] +'/' + self.text_field(attribute, control_options)
    end
    control_options[:after] = '</div>'
    input_control(object, attribute, label_options, field, control_options)
  end
  
  private
  
    def input_control(object, attribute, label_options, field, control_options)
      label_text = label_options.extract!(:text)[:text]
      if(label_options.has_key?(:required))
        label_options.extract!(:required)[:required]
        label_options[:class] = 'required'
      end
      label = self.label(attribute, label_text, label_options)
      output  = '<dt>' + label + '</dt>'
      output += '<dd>'
      output += control_options[:before] unless control_options[:before].nil?
      output += field
      output += control_options[:after] unless control_options[:after].nil?
      unless object.errors[attribute].empty?
        output += '<div class="error_description">' + object.errors[attribute].first + '</div>'
      end
      output += '</dd>'
      output.to_s.html_safe
    end

end