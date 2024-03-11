defmodule Dispatcher do
  use Matcher

  define_accept_types [
    json: [ "application/json", "application/vnd.api+json" ],
    html: [ "text/html", "application/xhtml+html" ],
    sparql: [ "application/sparql-results+json" ],
    any: [ "*/*" ]
  ]

  define_layers [ :static, :sparql, :api_services, :frontend_fallback, :resources, :not_found ]

  options "/*path", _ do
    conn
    |> Plug.Conn.put_resp_header( "access-control-allow-headers", "content-type,accept" )
    |> Plug.Conn.put_resp_header( "access-control-allow-methods", "*" )
    |> send_resp( 200, "{ \"message\": \"ok\" }" )
  end

  ###############
  # STATIC
  ###############
  match "/assets/*path", %{ layer: :static } do
    forward conn, path, "http://frontend/assets/"
  end

  get "/@appuniversum/*path", %{ layer: :static } do
    forward conn, path, "http://frontend/@appuniversum/"
  end

  match "/index.html", %{ layer: :static } do
    forward conn, [], "http://frontend/index.html"
  end

  match "/favicon.ico", %{ layer: :static } do
    send_resp( conn, 404, "" )
  end

  #################
  # FRONTEND PAGES
  #################
  match "/*_path", %{ layer: :frontend_fallback, accept: %{ html: true } } do
    forward conn, [], "http://frontend/index.html"
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

  ###############
  # FILES
  ###############

  get "/files/:id/download" do
    forward conn, [], "http://file/files/" <> id <> "/download"
  end

  get "/files/*path" do
    forward conn, path, "http://resource/files/"
  end

  post "/file-service/files/*path" do
    forward conn, path, "http://file/files/"
  end

  delete "/files/*path" do
    forward conn, path, "http://file/files/"
  end

  ###############
  # RESOURCES
  ###############

  match "/generated-forms/*path", %{ layer: :resources, accept: %{ json: true } } do
    forward conn, path, "http://resource/generated-forms/"
  end

  match "/user-tests/*path", %{ layer: :resources, accept: %{ json: true } } do
    forward conn, path, "http://resource/user-tests/"
  end

  match "/concept-schemes/*path", %{ layer: :resources, accept: %{ json: true } } do
    forward conn, path, "http://resource/concept-schemes/"
  end

  match "/concepts/*path", %{ layer: :resources, accept: %{ json: true } } do
    forward conn, path, "http://resource/concepts/"
  end

  #################
  # NOT FOUND
  #################
  match "/*_path", %{ layer: :not_found } do
    send_resp( conn, 404, "Route not found.  See config/dispatcher.ex" )
  end

end
