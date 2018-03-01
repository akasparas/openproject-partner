OpenProject::Application.routes.draw do
  resources :partners do
    member do
      get :filter_available_members

      post 'delete_member/:member_id', to: 'partners#delete_member', as: 'delete_member'
      post :add_members

      put :set_partner

    end

    #put '/partners/set_partner/:project_id', to: 'partners#set_partner'

  end
end
