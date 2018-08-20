class ProjectsController < ApplicationController
  before_action :authenticate_user!
  def index
    @projects = current_user.projects
  end

  def new
    @project = Project.new
  end

  def create
    project = Project.new(project_params)
    current_user.projects << project
    redirect_to project_path(project)
  end

  def show
    @project = Project.find(params[:id])
    @branches = @project.branches.includes(commits: :warnings).last_commited
  end

  private

  def project_params
    params.require(:project).permit(:github_project_user, :github_project_name)
  end
end
