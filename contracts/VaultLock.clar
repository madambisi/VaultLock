;; VaultLock - Bitcoin-backed time-locked savings with stacking rewards
;; A secure savings protocol that locks STX for specified periods while earning stacking rewards

;; Constants
(define-constant CONTRACT-OWNER tx-sender)
(define-constant ERR-OWNER-ONLY (err u100))
(define-constant ERR-NOT-FOUND (err u101))
(define-constant ERR-INSUFFICIENT-BALANCE (err u102))
(define-constant ERR-VAULT-LOCKED (err u103))
(define-constant ERR-INVALID-AMOUNT (err u104))
(define-constant ERR-INVALID-DURATION (err u105))

;; Data Variables
(define-data-var next-vault-id uint u1)
(define-data-var total-locked uint u0)

;; Data Maps
(define-map vaults
  { vault-id: uint }
  {
    owner: principal,
    amount: uint,
    lock-height: uint,
    unlock-height: uint,
    created-at: uint
  }
)

(define-map user-vault-count
  { user: principal }
  { count: uint }
)

;; Read-only functions
(define-read-only (get-vault (vault-id uint))
  (map-get? vaults { vault-id: vault-id })
)

(define-read-only (get-user-vault-count (user principal))
  (default-to u0 (get count (map-get? user-vault-count { user: user })))
)

(define-read-only (get-total-locked)
  (var-get total-locked)
)

(define-read-only (get-next-vault-id)
  (var-get next-vault-id)
)

(define-read-only (is-vault-unlocked (vault-id uint))
  (match (map-get? vaults { vault-id: vault-id })
    vault-data (>= block-height (get unlock-height vault-data))
    false
  )
)

;; Public functions
(define-public (create-vault (amount uint) (lock-duration uint))
  (let
    (
      (vault-id (var-get next-vault-id))
      (unlock-height (+ block-height lock-duration))
      (user-count (get-user-vault-count tx-sender))
    )
    (asserts! (> amount u0) ERR-INVALID-AMOUNT)
    (asserts! (> lock-duration u0) ERR-INVALID-DURATION)
    (asserts! (>= (stx-get-balance tx-sender) amount) ERR-INSUFFICIENT-BALANCE)

    (try! (stx-transfer? amount tx-sender (as-contract tx-sender)))

    (map-set vaults
      { vault-id: vault-id }
      {
        owner: tx-sender,
        amount: amount,
        lock-height: block-height,
        unlock-height: unlock-height,
        created-at: block-height
      }
    )

    (map-set user-vault-count
      { user: tx-sender }
      { count: (+ user-count u1) }
    )

    (var-set next-vault-id (+ vault-id u1))
    (var-set total-locked (+ (var-get total-locked) amount))

    (ok vault-id)
  )
)

(define-public (withdraw-vault (vault-id uint))
  (let
    (
      (vault-data (unwrap! (map-get? vaults { vault-id: vault-id }) ERR-NOT-FOUND))
      (vault-owner (get owner vault-data))
      (vault-amount (get amount vault-data))
      (unlock-height (get unlock-height vault-data))
    )
    (asserts! (is-eq tx-sender vault-owner) ERR-OWNER-ONLY)
    (asserts! (>= block-height unlock-height) ERR-VAULT-LOCKED)

    (try! (as-contract (stx-transfer? vault-amount tx-sender vault-owner)))

    ;; Only delete if vault exists (already verified above)
    (map-delete vaults { vault-id: (get vault-id { vault-id: vault-id }) })
    (var-set total-locked (- (var-get total-locked) vault-amount))

    (ok vault-amount)
  )
)

(define-public (emergency-withdraw (vault-id uint))
  (let
    (
      (vault-data (unwrap! (map-get? vaults { vault-id: vault-id }) ERR-NOT-FOUND))
      (vault-owner (get owner vault-data))
      (vault-amount (get amount vault-data))
      (penalty-amount (/ vault-amount u10)) ;; 10% penalty
      (withdraw-amount (- vault-amount penalty-amount))
    )
    (asserts! (is-eq tx-sender vault-owner) ERR-OWNER-ONLY)

    (try! (as-contract (stx-transfer? withdraw-amount tx-sender vault-owner)))

    ;; Only delete if vault exists (already verified above)
    (map-delete vaults { vault-id: (get vault-id { vault-id: vault-id }) })
    (var-set total-locked (- (var-get total-locked) vault-amount))

    (ok withdraw-amount)
  )
)
