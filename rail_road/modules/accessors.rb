# frozen_string_literal: true

module Accessors
  def attr_accessor_with_history(*vars)
    vars.each do |var|
      var_name = "@#{var}".to_sym

      var_history = "#{var}_history"
      var_history_name = "@#{var_history}".to_sym

      define_method(var) { instance_variable_get(var_name) }
      define_method(var_history) { instance_variable_get(var_history_name) }

      define_method("#{var}=") do |value|
        var_history = instance_variable_get(var_history_name) || []
        var_prev_value = instance_variable_get(var_name)
        var_history << var_prev_value

        instance_variable_set(var_name, value)
        instance_variable_set(var_history_name, var_history)
      end
    end
  end

  def strong_attr_accessor(var, var_class)
    var_name = "@#{var}".to_sym

    define_method(var) { instance_variable_get(var_name) }

    define_method("#{var}=") do |value|
      raise ArgumentError, 'invalid_type' unless value.is_a? var_class

      instance_variable_set(var_name, value)
    end
  end
end
