# Transfer Note Contract

## Overview
The `TransferNote` contract enables the private transfer of data ownership within the Aztec network. It utilizes Zero-Knowledge Proofs (ZKP) to ensure that only the legitimate owner of a UTXO (Note) can transfer it to another party without revealing the identity of the sender, receiver, or the data being transferred.

## Technical Implementation
- **Note Structure**: Defined as a `Note` containing the `owner` address and a `data_hash` representing the encrypted data ownership.
- **Consumption**: The `transfer` function consumes an existing UTXO. The Aztec VM verifies the ZK proof that the caller possesses the private key associated with the note's owner.
- **Creation**: A new UTXO is emitted with the updated owner address, maintaining the integrity of the `data_hash`.

## How to Use
1. **Minting**: Use the `mint` function to create the initial ownership note.
2. **Transferring**: Call the `transfer` function providing the `old_note` (private input) and the `new_owner` address.

## Security
- All transactions are shielded.
- Ownership is verified via ZKPs.
- Prevents self-transfers to optimize state growth.
