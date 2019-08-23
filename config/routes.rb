Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
 namespace 'api' do
    namespace 'v1' do
      

      resources :movies,    defaults: { format: 'json' } do
        collection do
          get 'title/:title' , to: 'movies#show'
        end
      end
      resources :auditoria, defaults: { format: 'json' } do
      	collection do
      	  get 'title/:title' , to: 'auditoria#show'
      	end
      end

      resources :show_times, defaults: { format: 'json' }, path: :showtimes
      resources :tickets, defaults: { format: 'json' }


    end
  end
end
