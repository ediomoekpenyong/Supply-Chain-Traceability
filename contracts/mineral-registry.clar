;; Mineral Registry Contract

(define-map minerals
  { mineral-id: uint }
  {
    name: (string-ascii 50),
    origin: (string-ascii 100),
    initial-quantity: uint,
    registration-date: uint,
    registrar: principal
  }
)

(define-data-var mineral-id-nonce uint u0)

(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_UNAUTHORIZED (err u403))
(define-constant ERR_NOT_FOUND (err u404))
(define-constant ERR_ALREADY_EXISTS (err u409))

(define-read-only (get-mineral (mineral-id uint))
  (map-get? minerals { mineral-id: mineral-id })
)

(define-public (register-mineral (name (string-ascii 50)) (origin (string-ascii 100)) (initial-quantity uint))
  (let
    ((new-mineral-id (+ (var-get mineral-id-nonce) u1)))
    (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_UNAUTHORIZED)
    (map-set minerals
      { mineral-id: new-mineral-id }
      {
        name: name,
        origin: origin,
        initial-quantity: initial-quantity,
        registration-date: block-height,
        registrar: tx-sender
      }
    )
    (var-set mineral-id-nonce new-mineral-id)
    (ok new-mineral-id)
  )
)

(define-read-only (get-all-minerals)
  (ok (var-get mineral-id-nonce))
)

