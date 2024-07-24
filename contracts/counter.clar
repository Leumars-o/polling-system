
;; title: counter
;; version:
;; summary:
;; description:

;; traits
;;

;; token definitions
;;

;; constants
;; 

;; data vars
;;
;; Define data structure for storing individual poll counts

;; Define initial poll counts
(define-data-var biden-count uint u0)
(define-data-var trump-count uint u0)
(define-data-var total-poll uint u0)

;; Public function to add a vote for Biden
(define-public (add-poll-biden)
  (begin
    (var-set biden-count (+ (var-get biden-count) u1))
    (ok (var-set total-poll (+ (var-get total-poll) u1)))
  )
)

;; Public function to add a vote for Trump
(define-public (add-poll-trump)
    (begin
        (var-set trump-count (+ (var-get trump-count) u1))
        (ok (var-set total-poll (+ (var-get total-poll) u1)))
    )
)

;; Public function to retrieve total and individual poll counts
(define-read-only (get-poll-count)
  (begin
    (var-set total-poll (+ (var-get var-biden-count) (var-get var-trump-count)))
    (var-get total-poll)
  )
)

(define-read-only (get-poll-biden)
    (var-get biden-count)
)

(define-read-only (get-poll-trump)
    (var-get trump-count)
)
;; read only functions
;;

;; private functions
;;

