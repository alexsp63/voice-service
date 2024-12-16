# frozen_string_literal: true

class Did < ApplicationRecord
  self.table_name = 'dids'

  belongs_to :user, optional: true
end
