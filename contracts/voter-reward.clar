
;; title: voter-reward
;; version: 1.0
;; summary: A supporting contract for the voting system that implements a reward mechanism
;; description: This contract allows voters to claim rewards based on their participation

;; traits
;;

;; token definitions
;;

;; Constants
(define-constant ERR-NOT-AUTHORIZED (err u403))
(define-constant ERR-ALREADY-CLAIMED (err u401))
(define-constant ERR-NOT-VOTED (err u402))
(define-constant ERR-INSUFFICIENT-FUNDS (err u500))
(define-constant ERR-INVALID-AMOUNT (err u501))

;; Data variables
(define-data-var contract-owner principal tx-sender)
(define-data-var reward-amount uint u5) ;; 5 STX reward for voting
(define-data-var max-reward-amount uint u100) ;; 100 STX max reward for voting

;; Maps
(define-map claimed-rewards principal bool)

;; Define traits
(define-trait voting-trait
    (
        (has-voted (principal) (response bool uint))
    )
)

;; Public functions
;;
;; Claim reward for voting
(define-public (claim-reward (voting-contract principal))
  (let 
    (
        (has-voted (contract-call? voting-contract has-voted tx-sender))
        (has-claimed (default-to false (map-get? claimed-rewards tx-sender)))
    )
    (asserts! has-voted ERR-NOT-VOTED)
    (asserts! (not has-claimed) ERR-ALREADY-CLAIMED)
    (asserts! (>= (stx-get-balance (as-contract tx-sender)) (var-get reward-amount)) ERR-INSUFFICIENT-FUNDS)
    
    (try! (as-contract (stx-transfer? (var-get reward-amount) tx-sender tx-sender)))
    (map-set claimed-rewards tx-sender true)
    (ok (var-get reward-amount))
  )
)

;; Admin functions

;; Set reward amount
(define-public (set-reward-amount (new-amount uint))
  (begin
    (asserts! (is-eq tx-sender (var-get contract-owner)) ERR-NOT-AUTHORIZED)
    (asserts! (<= new-amount (var-get max-reward-amount)) ERR-INVALID-AMOUNT)
    (var-set reward-amount new-amount)
    (ok (var-set reward-amount new-amount))
  )
)

;; Set maximum reward amount
(define-public (set-max-reward-amount (new-max-amount uint))
    (begin
        (asserts! (is-eq tx-sender (var-get contract-owner)) ERR-NOT-AUTHORIZED)
        (asserts! (>= new-max-amount (var-get reward-amount)) ERR-INVALID-AMOUNT)
        (ok (var-set max-reward-amount new-max-amount))
    )
)

;; Withdraw funds
(define-public (withdraw-funds (amount uint))
  (begin
    (asserts! (is-eq tx-sender (var-get contract-owner)) ERR-NOT-AUTHORIZED)
    (asserts! (<= amount (as-contract (stx-get-balance tx-sender))) ERR-INSUFFICIENT-FUNDS)
    (as-contract (stx-transfer? amount tx-sender (var-get contract-owner)))
  )
)

;; Read-only functions

;; Check if a user has claimed their reward
(define-read-only (has-claimed-reward (user principal))
  (default-to false (map-get? claimed-rewards user))
)

;; Get the current reward amount
(define-read-only (get-reward-amount)
  (var-get reward-amount)
)

;; Get the maximum allowed reward amount
(define-read-only (get-max-reward-amount)
  (var-get max-reward-amount)
)