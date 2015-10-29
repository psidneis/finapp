module EnumHelper
  def enum_to_translated_option(klass, enum, enum_value, default = enum_value.to_s.titleize)
    key = "activerecord.attributes.#{klass.to_s.underscore.gsub('/', '_')}.#{enum}.#{enum_value}"
    translated = I18n.t(key, :default => default)
  end

  def enums_to_translated_options_array(klass, enum)
    enum_values = klass.send(enum)
    enum_values.map do |enum_value, db_value|
      translated = enum_to_translated_option(klass, enum, enum_value)
      [translated, enum_value]
    end.reject {|translated, enum_value| translated.blank?}
  end

  def options_for_enum(klass, enum, object)
    options = enums_to_translated_options_array(klass, enum.to_s.pluralize)
    # options_for_select(options, object.send(enum))
    options
  end
end