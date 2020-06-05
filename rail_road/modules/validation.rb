# frozen_string_literal: true

class ValidationError < StandardError; end

module Validation
  VALIDATION_RULES = {
    type: proc { |value, type| raise ValidationError, 'invalid_type' unless value.is_a? type },
    format: proc { |value, regexp| raise ValidationError, 'invalid_format' unless value =~ regexp },
    presence: proc { |value| raise ValidationError, 'invalid_presence' if value.to_s.empty? }
  }.freeze

  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    def validations
      @validations ||= []
    end

    def validate(attr_name, validation_type, validation_base = nil)
      validation_rule = VALIDATION_RULES[validation_type]

      @validations ||= []

      @validations << { attr_name: attr_name, validation_rule: validation_rule, validation_base: validation_base }
    end
  end

  module InstanceMethods
    def validate!
      self.class.validations.each do |validation|
        attr_value = instance_variable_get("@#{validation[:attr_name]}".to_sym)
        validation_base = validation[:validation_base]

        validation[:validation_rule].call(attr_value, validation_base)
      end
    end

    def valid?
      validate!
      true
    rescue ValidationError
      false
    end
  end
end
