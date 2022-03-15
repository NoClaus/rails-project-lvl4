# frozen_string_literal: true

class Web::Repositories::ChecksController < ApplicationController
  def create
    @repository = Repository.find(params[:repository_id])
    @check = @repository.checks.build

    if @check.save
      RepositoryCheckJob.perform_later @repository.id, @check.id
      redirect_to @repository, notice: t('.success')
    else
      redirect_to @repository
    end
  end

  def show
    @check = Repository::Check.find(params[:id])
  end
end
