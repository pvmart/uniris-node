defmodule UnirisWeb.Router do
  use UnirisWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :put_root_layout, {UnirisWeb.LayoutView, :root}
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # Add the on chain implementation of the uniris.io at the root of the webserver
  # TODO: review to put it on every node or as proxy somewhere forwading to a specific transaction chain explorer
  scope "/", UnirisWeb do
    pipe_through :browser

    get "/", RootController, :index
  end

  scope "/explorer", UnirisWeb do
    pipe_through :browser

    get "/", ExplorerController, :index
    live "/search", TransactionDetailsLive
    live "/transactions", TransactionListLive
  end

  scope "/api" do
    pipe_through :api

    get "/last_transaction/:address/content",
        UnirisWeb.TransactionController,
        :last_transaction_content

    forward "/graphiql",
            Absinthe.Plug.GraphiQL,
            schema: Schema,
            socket: UnirisWeb.UserSocket

    forward "/",
            Absinthe.Plug,
            schema: UnirisWeb.Schema
  end
end
