# frozen_string_literal: true

module ValidationChecker
  def valid?
    validate!
    true
  rescue ArgumentError
    false
  end
end
