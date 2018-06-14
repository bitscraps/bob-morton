class Commit < ActiveRecord::Base
  belongs_to :branch
  has_many :warnings
end
