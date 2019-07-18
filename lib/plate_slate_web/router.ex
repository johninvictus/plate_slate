defmodule PlateSlateWeb.Router do
  use PlateSlateWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/web", PlateSlateWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/" do
    pipe_through :api

    forward "/api", Absinthe.Plug, schema: PlateSlateWeb.Schema
    forward "/graphql", Absinthe.Plug.GraphiQL, schema: PlateSlateWeb.Schema, interface: :simple
  end
end
