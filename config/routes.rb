OpenProject::Application.routes.draw do
  # get 'contacts/index'

  # get 'contacts/show'

  # get 'contacts/create'

  # get 'contacts/update'

  # get 'contacts/edit'

  # get 'contacts/destroy'

  resources :partners do
    member do
      get :filter_available_members

      post :add_contact

      put :set_partner

    end

  end

  resources :contacts do
    member do
      post 'delete_partner/:partner_id', to: 'contacts#delete_partner', as: 'delete_partner'
      post :add_partner

      get :available_partners

    end 
  end

end
