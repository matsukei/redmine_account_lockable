require 'mailer'

class AccountLockableMailer < Mailer
  def account_locked(locked_user, login_log)
    @login_log = login_log
    admin_user_mails = User.active.where(admin: true).map { |admin_user| admin_user.mail }

    set_language_if_valid locked_user.language
    mail(to: [locked_user.mail], cc: admin_user_mails,
      subject: l(:text_account_locked_subject, user: locked_user.login))
  end

end
