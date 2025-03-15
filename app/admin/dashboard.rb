# frozen_string_literal: true
ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    # Remove the default welcome message
    # div class: "blank_slate_container", id: "dashboard_default_message" do
    #   span class: "blank_slate" do
    #     span I18n.t("active_admin.dashboard_welcome.welcome")
    #     small I18n.t("active_admin.dashboard_welcome.call_to_action")
    #   end
    # end
    
    columns do
      column do
        panel "Welcome to heartMe Admin" do
          para "From here you can manage users and admin accounts."
          para "Use the navigation menu above to access different sections."
        end
      end
    end
    
    columns do
      column do
        panel "User Management" do
          ul do
            li link_to("All Users (#{User.count})", admin_users_path)
            li link_to("Admin Users (#{AdminUser.count})", admin_admin_users_path)
          end
        end
      end
      
      column do
        panel "Recent Users" do
          table_for User.order(created_at: :desc).limit(5) do
            column :email
            column :created_at
            column do |user|
              link_to "View", admin_user_path(user)
            end
          end
          strong { link_to "View All Users", admin_users_path }
        end
      end
    end

    # Here is an example of a simple dashboard with columns and panels.
    #
    # columns do
    #   column do
    #     panel "Recent Posts" do
    #       ul do
    #         Post.recent(5).map do |post|
    #           li link_to(post.title, admin_post_path(post))
    #         end
    #       end
    #     end
    #   end

    #   column do
    #     panel "Info" do
    #       para "Welcome to ActiveAdmin."
    #     end
    #   end
    # end
  end # content
end
