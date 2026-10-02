# Verify Note ZKP Contract

## Overview
This contract implements Zero-Knowledge Proof (ZKP) verification for notes within the Aztec ecosystem. It allows the system to verify that a note meets specific quality and compliance standards without exposing the underlying sensitive data.

## Functionality
The contract validates three main pillars:
1. **Data Quality**: Ensures the `row_count` of the dataset matches the expected value.
2. **Compliance**: Ensures that no Personally Identifiable Information (PII) is present (`has_pii == false`).
3. **Integrity**: Validates the cryptographic hash of the note attributes against a public proof hash.

## Technical Details
- **Language**: Noir
- **Privacy**: All note attributes are handled as `private` inputs.
- **Verification**: The `main` function acts as the circuit entry point, asserting that all conditions are met. If any `assert` fails, the ZKP will not be generated/verified, ensuring only valid notes are accepted.

## How to Test
1. Navigate to `packages/aztec/contracts/verify_note`.
2. Use the Noir CLI to execute the circuit:
   ```bash
   nrf nvm install
   nrf b
   nrf e
   ```
