
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
(define-data-var harris-count uint u0)
(define-data-var total-poll uint u0)

;; define maps
(define-map voters principal bool)

;; Public function to add a vote for Biden
(define-public (add-poll-biden)
  (begin
    ;; Check if the caller has already voted
    (asserts! (is-none (map-get? voters tx-sender)) (err u401))

    ;; Check if 10 STX has been sent
    (asserts! (>= (stx-get-balance tx-sender) u10) (err u100))

    ;; Transfer 10 STX to the contract
    (try! (stx-transfer? u10 tx-sender (as-contract tx-sender)))

    ;; Increment the Biden count and total poll count
    (var-set biden-count (+ (var-get biden-count) u1))
    (var-set total-poll (+ (var-get total-poll) u1))

    ;; Mark the address as voted
    (map-set voters tx-sender true)

    ;; Return success status and updated balance
    (ok {
      message: "Thank you for voting! Your new balance is:",
      balance: (stx-get-balance tx-sender)
      })
  )
)

;; Public function to add a vote for Trump
(define-public (add-poll-trump)
  (begin
    ;; Check if address has already voted
    (asserts! (is-none (map-get? voters tx-sender)) (err u401))

    ;; Check if 10 STX has been sent
    (asserts! (>= (stx-get-balance tx-sender) u10) (err u100))

    ;; Transfer 10 STX to the contract
    (try! (stx-transfer? u10 tx-sender (as-contract tx-sender)))

    ;; Increment the Trump count and total poll count
    (var-set trump-count (+ (var-get trump-count) u1))
    (var-set total-poll (+ (var-get total-poll) u1))

    ;; Mark address as voted
    (map-set voters tx-sender true)
    
    ;; Return success status and updated balance
    (ok {
      message: "Thank you for voting! Your new balance is:",
      balance: (stx-get-balance tx-sender)
      })
  )
)

;; Public function to add a vote for Harris
(define-public (add-poll-harris)
  (begin
    ;; Check if address has already voted
    (asserts! (is-none (map-get? voters tx-sender)) (err u401))

    ;; Check if 10 STX has been sent
    (asserts! (>= (stx-get-balance tx-sender) u10) (err u100))

    ;; Transfer 10 STX to the contract
    (try! (stx-transfer? u10 tx-sender (as-contract tx-sender)))

    ;; Increment the Trump count and total poll count
    (var-set harris-count (+ (var-get harris-count) u1))
    (var-set total-poll (+ (var-get total-poll) u1))

    ;; Mark address as voted
    (map-set voters tx-sender true)
    
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
  ;; Check if the caller is the contract owner
  (if (is-eq (var-get contract-owner) tx-sender)
    (ok (var-get biden-count))
    (err u403)
  )
)

(define-read-only (get-poll-trump)
  ;; Check if the caller is the contract owner
  (if (is-eq (var-get contract-owner) tx-sender)
    (ok (var-get trump-count))
    (err u403)
  )
)

(define-read-only (get-poll-harris)
  ;; Check if the caller is the contract owner
  (if (is-eq (var-get contract-owner) tx-sender)
    (ok (var-get harris-count))
    (err u403)
  )
)

;; Function for the contract owner to withdraw the contract balance
(define-public (withdraw-stx (amount uint))
  (begin
    ;; Check if the caller is the contract owner
    (asserts! (is-eq tx-sender (var-get contract-owner)) (err u403))
    
    ;; Check if the contract has enough balance
    (asserts! (<= amount (as-contract (stx-get-balance tx-sender))) (err u500))
    
    ;; Transfer the amount to the contract owner
    (as-contract (try! (stx-transfer? amount tx-sender (var-get contract-owner))))
    
    ;; Return success and transferred amount
    (ok amount)
  )
)

;; private functions
;;

