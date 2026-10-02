use crate::note::{Note, ComplianceNote, NoteInitialization, initialize_note};

pub contract CreateNoteContract {
    // This function acts as the entry point for registering the note on-chain
    pub fn create_note(
        creator_proof: Field,
        expected_proof_hash: Field,
        data_hash: Field,
        owner: Field,
        usage_permissions: Field,
        privacy_proof: Field,
        model_hash: Field,
        governance_type: Field,
        compliance_proof: Field
    ) {
        let note = Note {
            data_hash,
            owner,
            usage_permissions,
            privacy_proof,
        };

        let compliance = ComplianceNote {
            model_hash,
            governance_type,
            compliance_proof,
        };

        let init_data = NoteInitialization {
            note,
            compliance,
        };

        // Validate the proof and the note structure
        let is_valid = initialize_note(creator_proof, expected_proof_hash, init_data);
        
        assert(is_valid, "Invalid proof or note initialization data provided");
    }
}
