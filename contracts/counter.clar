
;; title: counter
;; version:
;; summary:
;; description:

;; traits
;; (define-trait STX-Fungible-Token)

;; ;; token definitions
;; (define-token STX u128)

;; constants

;; data vars
(define-data-var contract-owner principal tx-sender)
(define-data-var biden-count uint u0)
(define-data-var trump-count uint u0)
(define-data-var total-poll uint u0)

;; Public function to add a vote for Biden
(define-public (add-poll-biden)
  (begin
    ;; Check if 10 STX has been sent
    (asserts! (>= (stx-get-balance tx-sender) u10) (err u100))

    ;; Transfer 10 STX to the contract
    (try! (stx-transfer? u10 tx-sender (as-contract tx-sender)))

    ;; Increment the Biden count and total poll count
    (var-set biden-count (+ (var-get biden-count) u1))
    (var-set total-poll (+ (var-get total-poll) u1))

    ;; Return success status and updated balance
    (ok (stx-get-balance tx-sender))
  )
)

;; Public function to add a vote for Trump
(define-public (add-poll-trump)
  (begin
    ;; Check if 10 STX has been sent
    (asserts! (>= (stx-get-balance tx-sender) u10) (err u100))

    ;; Transfer 10 STX to the contract
    (try! (stx-transfer? u10 tx-sender (as-contract tx-sender)))

    ;; Increment the Trump count and total poll count
    (var-set trump-count (+ (var-get trump-count) u1))
    (var-set total-poll (+ (var-get total-poll) u1))
    
    ;; Return success status and updated balance
    (ok {
      message: "Thank you for voting! Your new balance is:",
      balance: (stx-get-balance tx-sender)
      })
  )
)

;; read only functions to retrieve total and individual poll counts
(define-read-only (get-poll-count)
    ;; Check if the caller is the contract owner
    (if (is-eq (var-get contract-owner) tx-sender)
      (ok (var-get total-poll))
      (err u403)
    )
)

(define-read-only (get-poll-biden)
    (var-get biden-count)
)

(define-read-only (get-poll-trump)
    (var-get trump-count)
)

;; private functions
;;

