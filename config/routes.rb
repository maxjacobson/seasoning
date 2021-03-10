Rails.application.routes.draw do
  get '/', to: 'frontend#show'
  get '/*anything', to: 'frontend#show'
end
