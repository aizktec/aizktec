// packages/aztec/contracts/notes/model_compliance_note.nr
// Model Compliance Certification Note implementation for Aizktec

// Import the necessary Aztec.nr libraries
use dep::aztec::{
    note::{
        note_header::NoteHeader,
        note_interface::{Note, NoteInterface},
        utils as note_utils,
    },
    context::{PrivateContext},
    hash::{pedersen_hash},
    log::{emit_encrypted_log},
    oracle::{get_public_key},
    types::{address::AztecAddress, field::Field},
};

// Define the Model Compliance Certification Note struct
struct ModelComplianceNote {
    // The hash of the AI model to uniquely identify it
    model_hash: Field,
    // Specifies the attested property (e.g., "no PII," "bias-checked")
    compliance_type: Field,
    // The ZKP verifying the compliance claim
    proof: Field,
    // The entity (e.g., AI developer) that owns the attestation
    owner: AztecAddress,
    // Timestamp for when the certification was created
    timestamp: Field,
    // Optional expiration date for the certification
    expiration: Field,
    // Status of the certification (e.g., active, revoked)
    status: Field,
}

// Constants for status values
global STATUS_ACTIVE: Field = 1;
global STATUS_REVOKED: Field = 2;
global STATUS_EXPIRED: Field = 3;

// Define compliance types as constants for ease of use
global COMPLIANCE_TYPE_NO_PII: Field = 1;
global COMPLIANCE_TYPE_BIAS_CHECKED: Field = 2;
global COMPLIANCE_TYPE_REGULATORY_COMPLIANT: Field = 3;
global COMPLIANCE_TYPE_SECURITY_AUDITED: Field = 4;
global COMPLIANCE_TYPE_ETHICALLY_TRAINED: Field = 5;

// Implement the Note trait for ModelComplianceNote
impl Note for ModelComplianceNote {
    fn compute_note_hash(&self, header: &NoteHeader) -> Field {
        let note_content_hash = self.compute_content_hash();
        pedersen_hash([
            note_content_hash,
            header.compute_header_hash(),
        ])
    }

    fn compute_nullifier(&self, header: &NoteHeader, nonce: Field) -> Field {
        // Generate unique nullifier for this note
        pedersen_hash([
            self.compute_note_hash(header),
            nonce,
        ])
    }

    fn compute_content_hash(&self) -> Field {
        // Hash the note's content fields together
        pedersen_hash([
            self.model_hash,
            self.compliance_type,
            self.proof,
            self.owner.to_field(),
            self.timestamp,
            self.expiration,
            self.status,
        ])
    }
}

// Helper functions for the ModelComplianceNote
impl ModelComplianceNote {
    // Create a new compliance certification
    pub fn new(
        model_hash: Field,
        compliance_type: Field,
        proof: Field,
        owner: AztecAddress,
        timestamp: Field,
        expiration: Field,
    ) -> Self {
        Self {
            model_hash,
            compliance_type,
            proof,
            owner,
            timestamp,
            expiration,
            status: STATUS_ACTIVE,
        }
    }

    // Check if the certification is valid (not expired or revoked)
    pub fn is_valid(&self, current_time: Field) -> bool {
        self.status == STATUS_ACTIVE && (self.expiration == 0 || current_time < self.expiration)
    }

    // Create a new compliance note with updated status
    pub fn update_status(&self, new_status: Field) -> Self {
        Self {
            model_hash: self.model_hash,
            compliance_type: self.compliance_type,
            proof: self.proof,
            owner: self.owner,
            timestamp: self.timestamp,
            expiration: self.expiration,
            status: new_status,
        }
    }
}

// Lifecycle functions for ModelComplianceNote
// These functions create, update, and nullify compliance certification notes

// Create a new compliance certification note
fn create_compliance_certification(
    context: &mut PrivateContext,
    storage_slot: Field,
    model_hash: Field,
    compliance_type: Field,
    proof: Field,
    owner: AztecAddress,
    timestamp: Field,
    expiration: Field,
) -> Field {
    // Create the note
    let note = ModelComplianceNote::new(
        model_hash,
        compliance_type,
        proof,
        owner,
        timestamp,
        expiration,
    );

    // Create a header for the note
    let header = NoteHeader::new(context.this_address(), storage_slot);
    
    // Generate the note hash using the header
    let note_hash = note.compute_note_hash(&header);
    
    // Insert the note into the note hash tree
    context.create_note(storage_slot, note_hash);
    
    // Encrypt and emit the note as a log to be discovered by the owner
    let mut serialized = [0; 8];
    serialized[0] = note.model_hash;
    serialized[1] = note.compliance_type;
    serialized[2] = note.proof;
    serialized[3] = note.owner.to_field();
    serialized[4] = note.timestamp;
    serialized[5] = note.expiration;
    serialized[6] = note.status;
    serialized[7] = storage_slot;

    // Encrypt log for the owner
    let owner_key = get_public_key(note.owner);
    emit_encrypted_log(owner_key, serialized);
    
    note_hash
}

// Update a compliance certification note (e.g., to change status)
fn update_compliance_certification(
    context: &mut PrivateContext,
    storage_slot: Field,
    original_note: ModelComplianceNote,
    original_header: NoteHeader,
    new_status: Field,
) -> Field {
    // Calculate the original note hash
    let original_note_hash = original_note.compute_note_hash(&original_header);
    
    // Nullify the original note
    context.nullify(original_note_hash);
    
    // Create an updated note with the new status
    let updated_note = original_note.update_status(new_status);
    
    // Create a new header for the updated note
    let new_header = NoteHeader::new(context.this_address(), storage_slot);
    
    // Generate the new note hash
    let new_note_hash = updated_note.compute_note_hash(&new_header);
    
    // Insert the new note into the note hash tree
    context.create_note(storage_slot, new_note_hash);
    
    // Encrypt and emit the updated note as a log
    let mut serialized = [0; 8];
    serialized[0] = updated_note.model_hash;
    serialized[1] = updated_note.compliance_type;
    serialized[2] = updated_note.proof;
    serialized[3] = updated_note.owner.to_field();
    serialized[4] = updated_note.timestamp;
    serialized[5] = updated_note.expiration;
    serialized[6] = updated_note.status;
    serialized[7] = storage_slot;
    
    // Encrypt log for the owner
    let owner_key = get_public_key(updated_note.owner);
    emit_encrypted_log(owner_key, serialized);
    
    new_note_hash
}

// Nullify (revoke) a compliance certification note
fn revoke_compliance_certification(
    context: &mut PrivateContext,
    original_note: ModelComplianceNote,
    original_header: NoteHeader,
) -> Field {
    // Calculate the original note hash
    let original_note_hash = original_note.compute_note_hash(&original_header);
    
    // Nullify the note (mark it as spent)
    context.nullify(original_note_hash);
    
    original_note_hash
}