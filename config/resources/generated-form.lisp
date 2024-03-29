(define-resource generated-form ()
  :class (s-prefix "ext:GeneratedForm")
  :properties `((:created :string ,(s-prefix "dct:created"))
                (:modified :string ,(s-prefix "dct:modified"))
                (:label :string ,(s-prefix "skos:prefLabel"))
                (:comment :string ,(s-prefix "skos:comment"))
                (:ttl-code :string , (s-prefix "ext:ttlCode")))
  :resource-base (s-url "http://data.lblod.info/generated-forms/")
  :features `(include-uri)
  :on-path "generated-forms")