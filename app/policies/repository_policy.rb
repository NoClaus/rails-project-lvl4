# frozen_string_literal: true

class RepositoryPolicy < ApplicationPolicy
  def index?
    user
  end

  def new?
    user
  end

  def create?
    user
  end

  def show?
    user && author?
  end

  private

  def author?
    record.user == user
  end
end
