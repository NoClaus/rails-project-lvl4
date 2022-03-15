# frozen_string_literal: true

class Web::RepositoriesController < ApplicationController
  after_action :verify_authorized

  def index
    @repositories = current_user&.repositories&.order(created_at: :desc)
    authorize @repositories
  end

  def show
    @repository = Repository.find(params[:id])
    authorize @repository
    @checks = @repository.checks.order(created_at: :desc)
  end

  def new
    authorize Repository
    available_languages = Repository.language.values

    client = Octokit::Client.new access_token: current_user.token, per_page: 200
    @repos = client.repos
                   .select { |repo| repo.language.present? }
                   .filter { |repo| available_languages.include? repo.language.downcase }
                   .map { |repo| [repo.full_name, repo.id] }

    @repository = current_user.repositories.build
  end

  def create
    authorize Repository
    @repository = current_user.repositories.build(repository_params)
    @check = @repository.checks.build

    if @repository.save
      UpdateInfoRepositoryJob.perform_later @repository.id, @check.id
      redirect_to repositories_path, notice: t('.success')
    else
      render :new
    end
  end

  private

  def repository_params
    params.require(:repository).permit(:github_id)
  end
end