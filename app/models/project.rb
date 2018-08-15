class Project < ApplicationRecord
  has_and_belongs_to_many :users
  has_many :branches
  has_many :invitations

  def name
    "#{github_project_user}/#{github_project_name}"
  end
end
