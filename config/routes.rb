Rails.application.routes.draw do
  # get "/", to: "pages#home" 簡化如下
  root "pages#home"
  get "/about", to: "pages#about"
  get "/contact", to: "pages#contact"
end
