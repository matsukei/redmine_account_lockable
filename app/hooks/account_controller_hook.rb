module AccountLockable
  class AccountControllerHooks < Redmine::Hook::ViewListener
    def controller_account_success_authentication_after(context = {})
      user, request = context.values_at(:user, :request)

      login_log = LoginLog.find_or_create_by(user_id: user.id)
      login_log.success!(request.remote_ip)
    end
  end
end
