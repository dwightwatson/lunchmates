defmodule Lunchmates.Router do
  use Lunchmates.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Lunchmates.Auth, repo: Lunchmates.Repo
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Lunchmates do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    get "/login", SessionController, :new
    post "/login", SessionController, :create
    delete "/logout", SessionController, :delete

    get "/account", AccountController, :index
    put "/account", AccountController, :update
    delete "/account", AccountController, :delete

    resources "/users", UserController, only: [:index, :new, :create, :show]
    resources "/lunches", LunchController, only: [:index, :show]
    resources "/locations", LocationController
  end

  # Other scopes may use custom stacks.
  # scope "/api", Lunchmates do
  #   pipe_through :api
  # end
end
