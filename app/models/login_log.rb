class LoginLog < ActiveRecord::Base
  belongs_to :user

  DEFAULT_ALLOW_FAILED_ATTEMPTS = 5

  def failed!(remote_ip)
    self.update(failed_attempts: failed_attempts.next,
      last_failed_login_at: current_failed_login_at,
      current_failed_login_at: Time.zone.now,
      last_failed_login_ip: current_failed_login_ip,
      current_failed_login_ip: remote_ip)
  end

  def success!(remote_ip)
    self.unlock!

    self.update(last_sign_in_at: current_sign_in_at,
      current_sign_in_at: Time.zone.now,
      last_sign_in_ip: current_sign_in_ip,
      current_sign_in_ip: remote_ip)
  end

  def locked!
    self.update(last_locked_at: current_locked_at,
      current_locked_at: Time.zone.now)
  end

  def unlock!
    self.update(failed_attempts: 0)
  end

  def lockable?
    self.allow_failed_attempts < self.failed_attempts
  end

  def allow_failed_attempts
    setting_value = Setting.plugin_redmine_account_lockable[:allow_failed_attempts].to_s.to_i
    if setting_value.zero?
      LoginLog::DEFAULT_ALLOW_FAILED_ATTEMPTS
    else
      setting_value
    end
  end

end
