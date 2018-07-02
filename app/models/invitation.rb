class Invitation < ActiveRecord::Base
  belongs_to :project
  belongs_to :user, optional: true
end
