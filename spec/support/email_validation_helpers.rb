module EmailValidationHelpers
  def long_email(length = 1)
    a = ''
    (length-9).times { a << "a" }
    "#{a}@test.com"
  end
end