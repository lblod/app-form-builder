(in-package :mu-cl-resources)

(defparameter *include-count-in-paginated-responses* t
  "when non-nil, all paginated listings will contain the number
   of responses in the result object's meta.")

(read-domain-file "generated-form.lisp")
(read-domain-file "file.lisp")
(read-domain-file "concept-scheme.lisp")
  