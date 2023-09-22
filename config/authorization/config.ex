alias Acl.Accessibility.Always, as: AlwaysAccessible
alias Acl.Accessibility.ByQuery, as: AccessByQuery
alias Acl.GraphSpec.Constraint.Resource, as: ResourceConstraint
alias Acl.GraphSpec.Constraint.ResourceFormat, as: ResourceFormatConstraint
alias Acl.GraphSpec, as: GraphSpec
alias Acl.GroupSpec, as: GroupSpec
alias Acl.GroupSpec.GraphCleanup, as: GraphCleanup

defmodule Acl.UserGroups.Config do

  defp access_by_role( group_string ) do
    %AccessByQuery{
      vars: ["session_group","session_role"],
      query: sparql_query_for_access_role( group_string ) }
  end

  defp sparql_query_for_access_role( group_string ) do
    "PREFIX ext: <http://mu.semte.ch/vocabularies/ext/>
    PREFIX mu: <http://mu.semte.ch/vocabularies/core/>
    SELECT DISTINCT ?session_group ?session_role WHERE {
      <SESSION_ID> ext:sessionGroup/mu:uuid ?session_group;
                   ext:sessionRole ?session_role.
      FILTER( ?session_role = \"#{group_string}\" )
    }"
  end

  def user_groups do
    [
      # // PUBLIC
      %GroupSpec{
        name: "public",
        useage: [:read],
        access: %AlwaysAccessible{},
        graphs: [ %GraphSpec{
                    graph: "http://mu.semte.ch/graphs/public",
                    constraint: %ResourceConstraint{
                      resource_types: [
                      ]
                    } },
                    %GraphSpec{
                      graph: "http://mu.semte.ch/graphs/sessions",
                      constraint: %ResourceFormatConstraint{
                        resource_prefix: "http://mu.semte.ch/sessions/"
                    } }
                ] },
      # // FORM BUILDER
      %GroupSpec{
        name: "form-builder-rw",
        useage: [:read, :write],
        access: access_by_role( "ABB" ),
        graphs: [ %GraphSpec{
                    graph: "http://mu.semte.ch/graphs/form-builder/",
                    constraint: %ResourceConstraint{
                      resource_types: [
                        "http://lblod.data.gift/vocabularies/forms/",
                        "http://www.w3.org/ns/shacl#",
                        "http://mu.semte.ch/vocabularies/core/",
                        "http://lblod.data.gift/display-types/",
                        "http://mu.semte.ch/vocabularies/ext/",
                        "http://schema.org/",
                        "http://www.w3.org/1999/02/22-rdf-syntax-ns#",
                        "http://www.semanticdesktop.org/ontologies/2007/01/19/nie#",
                      ] 
                    } }
                ] },

      # // CLEANUP
      #
      %GraphCleanup{
        originating_graph: "http://mu.semte.ch/application",
        useage: [:write],
        name: "clean"
      }
    ]
  end
end