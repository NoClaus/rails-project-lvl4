# frozen_string_literal: true

require 'test_helper'

class Web::RepositoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    sign_in_as_user @user
  end

  test 'should get index' do
    get repositories_path
    assert_response :success
  end
end