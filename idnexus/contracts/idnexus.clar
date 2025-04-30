;; Decentralized Identity Verification Smart Contract

;; Define the contract owner
(define-constant admin-wallet 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM) ;; Replace with your address

;; Map to store user identities
(define-map user-registry principal { 
    full-name: (string-utf8 100), 
    contact-email: (string-utf8 100), 
    is-verified: bool 
})

;; Error codes
(define-constant ERROR_NOT_AUTHORIZED (err u1001))
(define-constant ERROR_DUPLICATE_ENTRY (err u1002))
(define-constant ERROR_ENTRY_MISSING (err u1003))

;; Function to register identity
(define-public (register-identity (full-name (string-utf8 100)) (contact-email (string-utf8 100)))
    (begin
        ;; Check if the caller already has an identity
        (asserts! (is-none (map-get? user-registry tx-sender)) ERROR_DUPLICATE_ENTRY)
        
        ;; Store the identity
        (map-set user-registry tx-sender { full-name: full-name, contact-email: contact-email, is-verified: false })
        
        ;; Return success
        (ok true)
    )
)

;; Function to verify identity (only callable by contract owner)
(define-public (verify-identity (account-address principal))
    (begin
        ;; Ensure only the contract owner can verify identities
        (asserts! (is-eq tx-sender admin-wallet) ERROR_NOT_AUTHORIZED)
        
        ;; Check if the user exists
        (asserts! (is-some (map-get? user-registry account-address)) ERROR_ENTRY_MISSING)
        
        ;; Update the verified status
        (map-set user-registry account-address (merge (unwrap! (map-get? user-registry account-address) ERROR_ENTRY_MISSING) { is-verified: true }))
        
        ;; Return success
        (ok true)
    )
)

;; Function to get identity information
(define-read-only (get-identity (account-address principal))
    (begin
        ;; Fetch the identity
        (match (map-get? user-registry account-address)
            user-data (ok user-data)
            (err ERROR_ENTRY_MISSING)
        )
    )
)

;; Function to delete identity (only callable by the user)
(define-public (delete-identity)
    (begin
        ;; Ensure the caller has an identity
        (asserts! (is-some (map-get? user-registry tx-sender)) ERROR_ENTRY_MISSING)
        
        ;; Delete the identity
        (map-delete user-registry tx-sender)
        
        ;; Return success
        (ok true)
    )
)