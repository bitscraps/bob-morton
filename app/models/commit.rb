class Commit < ActiveRecord::Base
  has_many :warnings
end
