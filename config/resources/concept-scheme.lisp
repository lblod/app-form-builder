(define-resource concept-scheme ()
  :class (s-prefix "skos:ConceptScheme")
  :properties `(
    (:prefLabel :string ,(s-prefix "skos:prefLabel"))
    (:description :string ,(s-prefix "skos:note"))
    (:isPublic :boolean ,(s-prefix "ext:isPublic"))
    (:isArchived :boolean ,(s-prefix "ext:isArchived"))
    (:createdAt :string ,(s-prefix "dct:created"))
    )
  :has-many `((concept :via ,(s-prefix "skos:inScheme")
                       :inverse t
                       :as "concepts"))
  :resource-base (s-url "http://lblod.data.gift/concept-schemes/")
  :features `(include-uri)
  :on-path "concept-schemes"
)

(define-resource concept ()
  :class (s-prefix "skos:Concept")
  :properties `(
    (:prefLabel :string ,(s-prefix "skos:prefLabel"))
    (:order :number ,(s-prefix "qb:order"))
    )
  :has-many `((concept-scheme :via ,(s-prefix "skos:inScheme")
                              :as "concept-schemes"))
  :resource-base (s-url "http://lblod.data.gift/concepts/")
  :features `(include-uri)
  :on-path "concepts"
)
