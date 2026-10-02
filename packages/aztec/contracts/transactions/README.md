# Privacy-Preserving Transactions Contract

This directory contains the Noir smart contract implementation for secure, private asset transfers within the Aztec ecosystem.

## Features
- **Confidential Transfers**: Leverages Noir's ZK capabilities to ensure transaction amounts and balances remain private.
- **Strict Validation**: Implements balance checks before any state transition to prevent overspending.
- **Access Control**: Ensures only the owner of the funds can initiate a transfer via signature verification.
- **Atomic Updates**: Updates both sender and receiver balances in a single transactional flow.

## Technical Details
- **Language**: Noir
- **Framework**: Aztec Network
- **Logic**: 
    - `initiate_transaction`: Validates ownership and funds, then triggers the transfer.
    - `receive_funds`: Updates the recipient's balance.

## How to Test
1. Navigate to `packages/aztec/contracts/transactions`.
2. Run `noir check` to validate the circuit.
3. Use the Aztec Sandbox to deploy and execute transactions.
