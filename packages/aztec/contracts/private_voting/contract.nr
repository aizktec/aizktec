use std;

// --- Constants & Types ---
const MAX_OPTIONS: usize = 10;

#[derive(AsPublic)]
struct VotingConfig {
    voting_start: u64,
    voting_end: u64,
}

#[derive(AsPublic)]
struct VoteTally {
    counts: [u32; MAX_OPTIONS],
}

// --- Errors ---
enum VotingError {
    VotingNotStarted,
    VotingEnded,
    InvalidOption,
    AlreadyVoted,
}

// --- State ---
// In Aztec Noir contracts, state is managed via the Aztec SDK.
// We define the logic for the private functions here.

#[derive(AsPublic)]
struct VoteCast {
    option_index: u32,
}

/// The main voting contract logic
pub fn cast_vote(
    config: VotingConfig,
    current_time: u64,
    option_index: u32,
    voter_id: Field,
    nullifier: Field,
) -> VoteCast {
    // 1. Validation: Check if voting is active
    assert(current_time >= config.voting_start, VotingError::VotingNotStarted);
    assert(current_time <= config.voting_end, VotingError::VotingEnded);

    // 2. Validation: Check if the option is within valid range
    assert(option_index < MAX_OPTIONS as u32, VotingError::InvalidOption);

    // 3. Privacy Logic: 
    // In a real Aztec deployment, the nullifier is checked against the 
    // on-chain nullifier set to prevent double voting.
    // The voter_id is used to derive the nullifier privately.
    
    // Verify that the nullifier is correctly derived from the voter_id 
    // (Simplified for Noir logic representation)
    let expected_nullifier = std::hash::pedersen_hash([voter_id]);
    assert(nullifier == expected_nullifier, VotingError::AlreadyVoted);

    VoteCast { option_index }
}

/// Function to tally the results (usually called by an admin or public function)
pub fn tally_votes(votes: Vec<VoteCast>) -> VoteTally {
    let mut counts = [0u32; MAX_OPTIONS];
    
    for vote in votes {
        let idx = vote.option_index as usize;
        counts[idx] = counts[idx] + 1;
    }
    
    VoteTally { counts }
}
