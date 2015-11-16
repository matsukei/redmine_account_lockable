require_dependency 'account_controller'

module AccountLockable
  module AccountControllerPatch
    # unloadable

    extend ActiveSupport::Concern

    included do
      # unloadable

      alias_method_chain :invalid_credentials, :account_lock
    end

    def invalid_credentials_with_account_lock
      invalid_credentials_without_account_lock
      return if params[:username].blank?

      user = User.active.find_by_login(params[:username])
      return if user.blank?

      login_log = LoginLog.find_or_create_by(user_id: user.id)
      login_log.failed!(request.remote_ip)

      if login_log.lockable?
        user.lock!
        login_log.locked!

        AccountLockableMailer.account_locked(user, login_log).deliver
      end
    end

  end
end

AccountLockable::AccountControllerPatch.tap do |mod|
  AccountController.send :include, mod unless AccountController.include?(mod)
end
