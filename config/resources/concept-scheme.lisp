(define-resource concept-scheme ()
  :class (s-prefix "skos:ConceptScheme")
  :properties `(
    (:prefLabel :string ,(s-prefix "skos:prefLabel"))
    )
  :has-many `((concept :via ,(s-prefix "core:inScheme")
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
    )
  :has-many `((concept-scheme :via ,(s-prefix "core:inScheme")
                              :as "concept-schemes"))
  :resource-base (s-url "http://lblod.data.gift/concepts/")
  :features `(include-uri)
  :on-path "concepts"
)
