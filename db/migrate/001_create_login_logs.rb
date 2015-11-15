class CreateLoginLogs < ActiveRecord::Migration
  def change
    create_table :login_logs do |t|
      t.integer :user_id, index: true

      t.integer :sign_in_count, default: 0
      t.integer :failed_attempts, default: 0

      t.time :current_sign_in_at
      t.time :last_sign_in_at

      t.string :current_sign_in_ip
      t.string :last_sign_in_ip

      t.time :current_failed_login_at
      t.time :last_failed_login_at

      t.string :current_failed_login_ip
      t.string :last_failed_login_ip

      t.time :current_locked_at
      t.time :last_locked_at
    end
  end
end
