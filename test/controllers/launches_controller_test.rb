require 'test_helper'

class LaunchesControllerTest < ActionController::TestCase
  setup do
    @launch = launches(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:launches)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create launch" do
    assert_difference('Launch.count') do
      post :create, launch: { amount_installment: @launch.amount_installment, category_id: @launch.category_id, date: @launch.date, description: @launch.description, launchable_id: @launch.launchable_id, launchable_type: @launch.launchable_type, paid: @launch.paid, recurrence: @launch.recurrence, recurrence_type: @launch.recurrence_type, title: @launch.title, type: @launch.type, user_id: @launch.user_id, value: @launch.value }
    end

    assert_redirected_to launch_path(assigns(:launch))
  end

  test "should show launch" do
    get :show, id: @launch
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @launch
    assert_response :success
  end

  test "should update launch" do
    patch :update, id: @launch, launch: { amount_installment: @launch.amount_installment, category_id: @launch.category_id, date: @launch.date, description: @launch.description, launchable_id: @launch.launchable_id, launchable_type: @launch.launchable_type, paid: @launch.paid, recurrence: @launch.recurrence, recurrence_type: @launch.recurrence_type, title: @launch.title, type: @launch.type, user_id: @launch.user_id, value: @launch.value }
    assert_redirected_to launch_path(assigns(:launch))
  end

  test "should destroy launch" do
    assert_difference('Launch.count', -1) do
      delete :destroy, id: @launch
    end

    assert_redirected_to launches_path
  end
end
