Rails.application.config.after_initialize do
    ActiveRecord::Base.connection.data_source_exists?('spree_users') && defined?(Spree::Auth) && begin
      if Spree::User.count.zero? && ENV['ADMIN_EMAIL'] && ENV['ADMIN_PASSWORD']
        admin = Spree::User.create!(
          email: ENV['ADMIN_EMAIL'],
          password: ENV['ADMIN_PASSWORD'],
          password_confirmation: ENV['ADMIN_PASSWORD']
        )
        admin_role = Spree::Role.find_or_create_by!(name: 'admin')
        admin.spree_roles << admin_role
      end
    rescue ActiveRecord::NoDatabaseError, ActiveRecord::StatementInvalid
      # Handle case where database/tables don't exist yet
    end
  end