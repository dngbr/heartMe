ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation, :confirmed_at
  
  # Display these columns in the index view
  index do
    selectable_column
    id_column
    column :email
    column :confirmed_at
    column "Profile Name" do |user|
      user.profile&.name
    end
    column "Profile Bio" do |user|
      user.profile&.bio&.truncate(50)
    end
    column :created_at
    actions
  end
  
  # Customize the filter sidebar
  filter :email
  filter :confirmed_at
  filter :created_at
  
  # Customize the form for creating/editing users
  form do |f|
    f.inputs "User Details" do
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :confirmed_at, as: :datepicker, hint: "Set this to confirm the user's email"
    end
    f.actions
  end
  
  # Customize the show page
  show do
    attributes_table do
      row :id
      row :email
      row :confirmed_at
      row :confirmation_sent_at
      row :created_at
      row :updated_at
    end
    
    panel "Profile Information" do
      if user.profile
        attributes_table_for user.profile do
          row :id
          row :name
          row :bio
          row :share_id
          row :created_at
          row :updated_at
          row "Profile Picture" do
            if user.profile.profile_picture.attached?
              image_tag url_for(user.profile.profile_picture), style: "max-width: 200px; max-height: 200px;"
            else
              "No profile picture"
            end
          end
          row "Background Picture" do
            if user.profile.background_picture.attached?
              image_tag url_for(user.profile.background_picture), style: "max-width: 300px; max-height: 150px;"
            else
              "No background picture"
            end
          end
        end
      else
        div class: "blank_slate_container" do
          span class: "blank_slate" do
            span "No Profile Created Yet"
          end
        end
      end
    end
    active_admin_comments
  end
  
  # Add a custom action to manually confirm a user
  member_action :confirm, method: :put do
    resource.confirm
    redirect_to resource_path, notice: "User has been confirmed!"
  end
  
  # Add a button to the actions column for confirming users
  action_item :confirm, only: :show do
    if !resource.confirmed?
      link_to 'Confirm User', confirm_admin_user_path(resource), method: :put
    end
  end
end
