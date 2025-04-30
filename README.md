# IDNexus

**IDNexus** is a decentralized identity verification smart contract built on the Stacks blockchain using the Clarity language. It allows users to register, manage, and verify their identities securely on-chain without relying on centralized intermediaries.

---

## 🔐 Features

- **Decentralized Identity Registration**: Users can register their name and email on the blockchain.
- **Owner-Based Verification**: Only the contract owner has the authority to verify user identities.
- **On-Chain Identity Management**: Users can view and delete their identity records anytime.
- **Tamper-Resistant**: Data is stored immutably and securely using blockchain technology.

---

## 🛠 Functions

### `register-identity (name string) (email string)`
Registers a new identity for the caller.

- **Access**: Public  
- **Returns**: `(ok true)` on success or error if already registered.  
- **Errors**:
  - `ERR_ALREADY_VERIFIED (err u1002)`: Identity already exists.

---

### `verify-identity (user principal)`
Verifies a user's identity (sets `verified` to `true`).

- **Access**: Contract owner only  
- **Returns**: `(ok true)` on success  
- **Errors**:
  - `ERR_UNAUTHORIZED (err u1001)`: Caller is not the contract owner.
  - `ERR_NOT_FOUND (err u1003)`: Identity not found.

---

### `get-identity (user principal)`
Retrieves identity information for a given user.

- **Access**: Read-only  
- **Returns**:  
  - `(ok identity)` if found  
  - `(err ERR_NOT_FOUND)` if not

---

### `delete-identity`
Deletes the caller's identity from the system.

- **Access**: Public (only for the identity owner)  
- **Returns**: `(ok true)` on success  
- **Errors**:
  - `ERR_NOT_FOUND (err u1003)`: Identity not found.

---

## 🧾 Data Structures

### Identity Record
```clarity
{
  name: (string-utf8 100),
  email: (string-utf8 100),
  verified: bool
}
```

---

## 🔒 Access Control

Only the designated `contract-owner` (defined at deployment) can verify user identities. All other actions are permissionless but scoped to the calling user.

---

## 📦 Deployment

1. Replace the `contract-owner` address in the contract with your Stacks address.
2. Deploy the contract using the Stacks CLI or Clarity IDE.
3. Interact with the contract via a frontend dApp or directly using tools like Hiro Web Wallet or Clarinet.

---

## 🧪 Testing

Make sure to test each function:
- Register and retrieve an identity.
- Attempt to verify as a non-owner.
- Delete the identity and check that retrieval fails.

---

## 🧠 License

MIT License © 2025 — [Your Name or Organization]