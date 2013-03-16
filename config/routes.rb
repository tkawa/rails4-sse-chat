Rails4SseChat::Application.routes.draw do
  resources :messages do
    collection do
      get :events
    end
  end
  root to: 'messages#index'
end
