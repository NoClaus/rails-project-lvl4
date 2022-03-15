# frozen_string_literal: true

class Repository::Check < ApplicationRecord
  include AASM

  belongs_to :repository

  aasm column: :aasm_state do
    state :created, initial: true
    state :checking
    state :finished
    state :failure

    event :check do
      transitions from: :created, to: :checking
    end

    event :finish do
      transitions from: :checking, to: :finished
    end

    event :reject do
      transitions from: :checking, to: :failure
    end
  end
end
