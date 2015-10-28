class DatepickerInput < SimpleForm::Inputs::Base
  enable :placeholder, :maxlength, :pattern
  
  def input(wrapper_options)
    new_input_html_options = input_html_options.try(:dup)
#    if I18n.site == 2
#      new_input_html_options[:class] ||= []
#      new_input_html_options[:class] << :'form-control'
#    end
    # new_input_html_options.merge!({:type => 'datetime-local'})
    new_input_html_options.merge!({:value => I18n.l(object.send(attribute_name), :format => :date_picker )}) unless object.send(attribute_name).nil?
    @builder.text_field(attribute_name, new_input_html_options)
    # + \ @builder.hidden_field(attribute_name, { :class => attribute_name.to_s + "-alt"}) 
  end
end