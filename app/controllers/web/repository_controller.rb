# frozen_string_literal: true

class Web::RepositoriesController < ApplicationController
  after_action :verify_authorized

  def index
    authorize @repositories
    @repositories = current_user.repositories
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

    if @repository.save
      RepositoryLoaderJob.perform_later @repository.id, current_user.token
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
