require_dependency 'user'

module AccountLockable
  module UserPatch
    # unloadable

    extend ActiveSupport::Concern

    included do
      # unloadable

      after_update :unlock!
    end

    def unlock!
      if self.status_changed?
        self.status_was == User::STATUS_LOCKED

        login_log = LoginLog.find_or_create_by(user_id: self.id)
        login_log.unlock!
      end
    end
  end
end

AccountLockable::UserPatch.tap do |mod|
  User.send :include, mod unless User.include?(mod)
end
