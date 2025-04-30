// packages/aztec/contracts/notes/model_compliance_note_test.nr
// Test file for the Model Compliance Certification Note

use dep::aztec::{
    context::{PrivateContext},
    note::{
        note_header::NoteHeader,
        note_interface::{Note},
    },
    types::{address::AztecAddress, field::Field},
};

use crate::notes::model_compliance_note::{
    ModelComplianceNote,
    STATUS_ACTIVE,
    STATUS_REVOKED,
    COMPLIANCE_TYPE_NO_PII,
    create_compliance_certification,
    update_compliance_certification,
    revoke_compliance_certification,
};

// Test creating a new compliance certification note
#[test]
fn test_create_certification() {
    // Setup test parameters
    let model_hash = 0x123456789abcdefu64;
    let compliance_type = COMPLIANCE_TYPE_NO_PII;
    let proof = 0xabcdef123456789u64;
    let owner = AztecAddress::from_field(1);
    let timestamp = 1619776800; // Unix timestamp
    let expiration = 1651312800; // Unix timestamp one year later
    let storage_slot = 42;
    
    // Create the note object directly
    let note = ModelComplianceNote::new(
        model_hash,
        compliance_type,
        proof,
        owner,
        timestamp,
        expiration,
    );
    
    // Verify the note's properties
    assert(note.model_hash == model_hash, "Model hash doesn't match");
    assert(note.compliance_type == compliance_type, "Compliance type doesn't match");
    assert(note.proof == proof, "Proof doesn't match");
    assert(note.owner.to_field() == owner.to_field(), "Owner doesn't match");
    assert(note.timestamp == timestamp, "Timestamp doesn't match");
    assert(note.expiration == expiration, "Expiration doesn't match");
    assert(note.status == STATUS_ACTIVE, "Status should be active");
    
    // Test validity check
    assert(note.is_valid(timestamp + 100), "Note should be valid");
    assert(!note.is_valid(expiration + 100), "Note should be invalid after expiration");
}

// Test updating a certification's status
#[test]
fn test_update_certification_status() {
    // Create initial note
    let model_hash = 0x123456789abcdefu64;
    let compliance_type = COMPLIANCE_TYPE_NO_PII;
    let proof = 0xabcdef123456789u64;
    let owner = AztecAddress::from_field(1);
    let timestamp = 1619776800;
    let expiration = 1651312800;
    
    let original_note = ModelComplianceNote::new(
        model_hash,
        compliance_type,
        proof,
        owner,
        timestamp,
        expiration,
    );
    
    // Update the status
    let updated_note = original_note.update_status(STATUS_REVOKED);
    
    // Verify the updated note
    assert(updated_note.model_hash == model_hash, "Model hash should not change");
    assert(updated_note.compliance_type == compliance_type, "Compliance type should not change");
    assert(updated_note.proof == proof, "Proof should not change");
    assert(updated_note.owner.to_field() == owner.to_field(), "Owner should not change");
    assert(updated_note.timestamp == timestamp, "Timestamp should not change");
    assert(updated_note.expiration == expiration, "Expiration should not change");
    assert(updated_note.status == STATUS_REVOKED, "Status should be revoked");
    
    // Test validity after status change
    assert(!updated_note.is_valid(timestamp + 100), "Revoked note should be invalid");
}

// Mock PrivateContext for testing
struct MockPrivateContext {
    address: AztecAddress,
    nullified_notes: [Field; 10],
    nullified_count: u8,
    created_notes: [Field; 10],
    created_count: u8,
}

impl MockPrivateContext {
    fn new(address: AztecAddress) -> Self {
        Self {
            address,
            nullified_notes: [0; 10],
            nullified_count: 0,
            created_notes: [0; 10],
            created_count: 0,
        }
    }
}

impl PrivateContext for MockPrivateContext {
    fn this_address(&self) -> AztecAddress {
        self.address
    }
    
    fn nullify(&mut self, note_hash: Field) {
        self.nullified_notes[self.nullified_count] = note_hash;
        self.nullified_count += 1;
    }
    
    fn create_note(&mut self, storage_slot: Field, note_hash: Field) {
        self.created_notes[self.created_count] = note_hash;
        self.created_count += 1;
    }
    
    // Implement other required methods as needed
    // ...
}

// Test lifecycle functions
#[test]
fn test_lifecycle_functions() {
    // Setup parameters
    let model_hash = 0x123456789abcdefu64;
    let compliance_type = COMPLIANCE_TYPE_NO_PII;
    let proof = 0xabcdef123456789u64;
    let owner = AztecAddress::from_field(1);
    let timestamp = 1619776800;
    let expiration = 1651312800;
    let storage_slot = 42;
    
    // Create a mock context
    let contract_address = AztecAddress::from_field(2);
    let mut context = MockPrivateContext::new(contract_address);
    
    // Test create_compliance_certification
    let note_hash = create_compliance_certification(
        &mut context,
        storage_slot,
        model_hash,
        compliance_type,
        proof,
        owner,
        timestamp,
        expiration,
    );
    
    assert(context.created_count == 1, "Should have created one note");
    assert(context.created_notes[0] == note_hash, "Note hash mismatch");
    
    // Create a note and header for testing update and revoke
    let note = ModelComplianceNote::new(
        model_hash,
        compliance_type,
        proof,
        owner,
        timestamp,
        expiration,
    );
    let header = NoteHeader::new(contract_address, storage_slot);
    
    // Test update_compliance_certification
    let updated_hash = update_compliance_certification(
        &mut context,
        storage_slot,
        note,
        header,
        STATUS_REVOKED,
    );
    
    assert(context.nullified_count == 1, "Should have nullified one note");
    assert(context.created_count == 2, "Should have created two notes total");
    
    // Test revoke_compliance_certification
    let revoked_hash = revoke_compliance_certification(
        &mut context,
        note,
        header,
    );
    
    assert(context.nullified_count == 2, "Should have nullified two notes total");
    assert(revoked_hash == note.compute_note_hash(&header), "Revoked hash mismatch");
}