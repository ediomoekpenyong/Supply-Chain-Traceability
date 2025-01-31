;; Batch NFT Contract

(define-non-fungible-token batch-nft uint)

(define-map batch-nft-data
  { token-id: uint }
  {
    mineral-id: uint,
    batch-quantity: uint,
    origin: (string-ascii 100),
    current-owner: principal,
    creation-date: uint
  }
)

(define-data-var token-id-nonce uint u0)

(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_UNAUTHORIZED (err u403))
(define-constant ERR_NOT_FOUND (err u404))

(define-read-only (get-last-token-id)
  (ok (var-get token-id-nonce))
)

(define-read-only (get-token-uri (token-id uint))
  (ok none)
)

(define-read-only (get-owner (token-id uint))
  (ok (nft-get-owner? batch-nft token-id))
)

(define-public (transfer (token-id uint) (sender principal) (recipient principal))
  (begin
    (asserts! (is-eq tx-sender sender) ERR_UNAUTHORIZED)
    (try! (nft-transfer? batch-nft token-id sender recipient))
    (let
      ((batch-data (unwrap! (map-get? batch-nft-data { token-id: token-id }) ERR_NOT_FOUND)))
      (map-set batch-nft-data
        { token-id: token-id }
        (merge batch-data { current-owner: recipient })
      )
      (ok true)
    )
  )
)

(define-public (mint-batch-nft (mineral-id uint) (batch-quantity uint) (origin (string-ascii 100)))
  (let
    ((new-token-id (+ (var-get token-id-nonce) u1)))
    (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_UNAUTHORIZED)
    (try! (nft-mint? batch-nft new-token-id tx-sender))
    (map-set batch-nft-data
      { token-id: new-token-id }
      {
        mineral-id: mineral-id,
        batch-quantity: batch-quantity,
        origin: origin,
        current-owner: tx-sender,
        creation-date: block-height
      }
    )
    (var-set token-id-nonce new-token-id)
    (ok new-token-id)
  )
)

(define-read-only (get-batch-nft-data (token-id uint))
  (map-get? batch-nft-data { token-id: token-id })
)

