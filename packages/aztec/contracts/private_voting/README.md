# Private Voting Contract

This contract implements a private voting system using Noir and the Aztec Protocol.

## Architecture
- **Privacy**: Uses ZK proofs to ensure that the identity of the voter and their specific choice remain private.
- **Double-Voting Prevention**: Implements a nullifier system. Each voter generates a unique nullifier based on their secret key; if the nullifier has been seen before, the vote is rejected.
- **Time-Bound**: Voting is only permitted between `voting_start` and `voting_end`.

## Functions
- `cast_vote`: Validates the time window, the option index, and the nullifier before recording a vote.
- `tally_votes`: Aggregates the cast votes into a final tally.

## Deployment
To compile this contract, use:
```bash
nargo check
