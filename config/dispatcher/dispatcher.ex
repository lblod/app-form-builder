defmodule Dispatcher do
  use Matcher

  define_accept_types [
    json: [ "application/json", "application/vnd.api+json" ],
    html: [ "text/html", "application/xhtml+html" ],
    sparql: [ "application/sparql-results+json" ],
    any: [ "*/*" ]
  ]

  define_layers [ :static, :sparql, :api_services, :frontend_fallback, :resources, :not_found ]

  options "*path", _ do
    conn
    |> Plug.Conn.put_resp_header( "access-control-allow-headers", "content-type,accept" )
    |> Plug.Conn.put_resp_header( "access-control-allow-methods", "*" )
    |> send_resp( 200, "{ \"message\": \"ok\" }" )
  end

  ###############
  # STATIC
  ###############

  # frontend
  match "/assets/*path", %{ layer: :static } do
    forward conn, path, "http://frontend/assets/"
  end

  match "/index.html", %{ layer: :static } do
    forward conn, [], "http://frontend/index.html"
  end

  match "/favicon.ico", %{ layer: :static } do
    send_resp( conn, 404, "" )
  end

  ###############
  # SPARQL
  ###############
  match "/sparql", %{ layer: :sparql, accept: %{ html: true } } do  # this for navigation to
    forward conn, [], "http://virtuoso:8890/sparql"
  end

  match "/sparql", %{ layer: :sparql, accept: %{ sparql: true } } do # this for exectting query
    forward conn, [], "http://virtuoso:8890/sparql"
  end

  #################
  # FRONTEND PAGES
  #################

  match "/*path", %{ layer: :frontend_fallback, accept: %{ html: true } } do
    # We forward path for fastboot
    forward conn, path, "http://frontend/"
  end

  # match "/favicon.ico", @any do
  #   send_resp( conn, 404, "" )
  # end

  ###############
  # RESOURCES
  ###############

  # get "/bestuurseenheden/*path", %{ layer: :resources, accept: %{ json: true } } do
  #   Proxy.forward conn, path, "http://cache/bestuurseenheden/"
  # end

  # get "/werkingsgebieden/*path", %{ layer: :resources, accept: %{ json: true } } do
  #   Proxy.forward conn, path, "http://cache/werkingsgebieden/"
  # end
  # get "/bestuurseenheid-classificatie-codes/*path", %{ layer: :resources, accept: %{ json: true } } do
  #   Proxy.forward conn, path, "http://cache/bestuurseenheid-classificatie-codes/"
  # end
  # get "/bestuursorganen/*path", %{ layer: :resources, accept: %{ json: true } } do
  #   Proxy.forward conn, path, "http://cache/bestuursorganen/"
  # end
  # get "/bestuursorgaan-classificatie-codes/*path", %{ layer: :resources, accept: %{ json: true } } do
  #   Proxy.forward conn, path, "http://cache/bestuursorgaan-classificatie-codes/"
  # end

  #################
  # NOT FOUND
  #################
  match "/*_path", %{ layer: :not_found } do
    send_resp( conn, 404, "Route not found.  See config/dispatcher.ex" )
  end

end
