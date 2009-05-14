require 'test_helper'

class ConceptosControllerTest < ActionController::TestCase
  test "should get index" do}
    get :index
    assert_response :success
    assert_not_nil assigns(:conceptos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create concepto" do
    assert_difference('Concepto.count') do
      post :create, :concepto => { }
    end

    assert_redirected_to concepto_path(assigns(:concepto))
  end

  test "should show concepto" do
    o=Concepto.build
    o.save!
    get :show, :id => o.to_param
    assert_response :success
  end

  test "should get edit" do
    o=Concepto.build
    o.save!
    get :edit, :id => o.to_param
    assert_response :success
  end

  test "should update concepto" do
    o=Concepto.build
    o.save!
    put :update, :id => o.to_param, :concepto => { }
    assert_redirected_to concepto_path(assigns(:concepto))
  end

  test "should destroy concepto" do
    o=Concepto.build
    o.save!
    assert_difference('Concepto.count', -1) do
      delete :destroy, :id => o.to_param
    end

    assert_redirected_to conceptos_path
  end
end
