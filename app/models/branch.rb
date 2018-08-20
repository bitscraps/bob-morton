class Branch < ActiveRecord::Base
  belongs_to :project
  has_many :commits

  scope :last_commited, -> { joins(:commits).order('commits.created_at DESC') }
end
