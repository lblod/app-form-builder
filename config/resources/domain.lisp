(in-package :mu-cl-resources)

(define-resource generated-form ()
  :class (s-prefix "ext:GeneratedForm")
  :properties `((:created :string ,(s-prefix "dct:created"))
                (:modified :string ,(s-prefix "dct:modified"))
                (:label :string ,(s-prefix "skos:prefLabel"))
                (:comment :string ,(s-prefix "skos:comment"))
                (:ttlcode :string , (s-prefix "ext:ttlCode")))
  :resource-base (s-url "http://data.lblod.info/generated-forms/")
  :on-path "generated-forms")

(define-resource file ()
  :class (s-prefix "nfo:FileDataObject")
  :properties `((:filename :string ,(s-prefix "nfo:fileName"))
                (:format :string ,(s-prefix "dct:format"))
                (:size :number ,(s-prefix "nfo:fileSize"))
                (:extension :string ,(s-prefix "dbpedia:fileExtension"))
                (:created :datetime ,(s-prefix "nfo:fileCreated")))
  :has-one `((file :via ,(s-prefix "nie:dataSource")
                   :inverse t
                   :as "download"))
  :resource-base (s-url "http://data.example.com/files/")
  :features `(include-uri)
  :on-path "files")
