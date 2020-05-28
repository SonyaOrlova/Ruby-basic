module ValidationChecker
  def valid?
    validate!
    true
  rescue
    false
  end
end