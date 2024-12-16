# frozen_string_literal: true

class User < ApplicationRecord
  self.table_name = 'users'

  has_many :dids
end
