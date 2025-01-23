# frozen_string_literal: true

DatabaseCleaner.clean_with(:truncation)

user = User.create!

Did.create!(
  number: '1234567890',
  user: user
)
