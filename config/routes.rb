Rails.application.routes.draw do
  get 'poloniex/index'

  get 'exmo/index'

  get 'fork/index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html


  root 'fork#index'

  get 'fork/find_forks'
  post 'fork/show_details'
  get 'exmo/find_forks'
  post 'exmo/show_details'

  post 'exmo/refresh_fork'
  post 'poloniex/refresh_fork'

  get 'poloniex/find_forks'
  post 'poloniex/show_details'

end
