require File.expand_path('../../test_helper', __FILE__)

class CodimdsControllerTest < RedmineCodimd::ControllerTest
  fixtures :projects,
           :users, :email_addresses, :user_preferences,
           :roles,
           :members,
           :member_roles

  def setup
    prepare_tests

    Setting.default_language = 'en'
    User.current = nil
  end

  def test_show
    @request.session[:user_id] = 2
    get :show

    assert_response :success
    assert_select 'a', html: /New CodiMD pad/
  end

  def test_show_in_project
    @request.session[:user_id] = 2
    get :show,
        params: { project_id: 1 }

    assert_response :success
    assert_include 'eCookbook', response.body
    assert_select 'a', html: /New CodiMD pad/
  end

  def test_no_access_to_show_with_inactive_module
    @request.session[:user_id] = 2
    get :show,
        params: { project_id: 3 }

    assert_response :forbidden
  end

  def test_show_requires_logon
    @request.session[:user_id] = nil
    get :show

    assert_response 302
  end

  def test_no_access_to_show_without_permission
    @request.session[:user_id] = 7
    get :show

    assert_response :forbidden
  end
end
