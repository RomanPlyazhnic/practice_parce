Rails.application.routes.draw do
  get 'main/index'
  get 'main/search'
  get 'main/parse'
  root 'main#index'
end
