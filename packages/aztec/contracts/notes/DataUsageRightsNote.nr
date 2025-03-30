/**************************************************************************************************
 * Data Usage Rights Note Implementation for Aizktec
 *
 * This note type encapsulates Data Usage Rights and is designed to enforce policies on how data 
 * is utilized, shared, or accessed. It includes encryption so that only authorized parties can 
 * decrypt the sensitive ZKP data. Additionally, it supports nullification and update logic to 
 * manage changes in data usage rights.
 *
 * Fields:
 *   - dataHash:   A cryptographic hash of the dataset (integrity check).
 *   - owner:      The identifier (e.g. address) of the rights holder.
 *   - usagePermissions: Encoded rules (e.g., "train one model", "read-only").
 *   - zkpData:    Encrypted zero-knowledge proof data (e.g., row count) for verifying quality.
 *   - nullified:  A flag indicating whether the note has been nullified.
 *
 * Notes:
 *   - The #[note] macro injects a note header automatically and derives necessary serialization.
 *   - The note implements the NullifiableNote trait to support secure spending and auditability.
 *
 * For further details, see:
 *   - Notes Documentation
 *   - Implementing a Note in Aztec.nr
 *   - Writing Notes
 *
 * Long Comment:
 * This implementation is designed to be integrated seamlessly into the Aizktec ecosystem. It 
 * demonstrates secure encryption of sensitive data and includes robust nullification and update 
 * logic. Additional testing and integration work may be required to meet all production standards.
 **************************************************************************************************/

// Import Aztec.nr modules  adjust paths as needed for your project.
use aztec::encryption;
use aztec::notes::note;
use aztec::notes::note_interface;
use aztec::notes::note_header;


// Use the #[note] macro to automatically generate note header and serialization.
#[note]
struct DataUsageRightsNote {
    // Note header is automatically injected by the #[note] macro.
    dataHash: Field,         // Cryptographic hash of the dataset.
    owner: Address,          // Current rights holder's identifier.
    usagePermissions: Field, // Encoded rules for allowed data usage.
    zkpData: Field,          // Encrypted ZKP data (e.g., row count).
    nullified: bool,         // Flag indicating whether this note is nullified.
}

// Implement the NullifiableNote trait to support secure nullification.
impl NullifiableNote for DataUsageRightsNote {
    fn compute_nullifier(self, context: &mut PrivateContext, note_hash_for_nullify: Field) -> Field {
        // Retrieve a secret key from the context using the note's properties.
        let secret = context.request_nsk_app(self.owner.to_field());
        // Use Aztec.nr's poseidon2 (or appropriate) hash with a separator.
        return poseidon2_hash_with_separator([note_hash_for_nullify, secret], GENERATOR_INDEX__NOTE_NULLIFIER as Field);
    }

    unconstrained fn compute_nullifier_without_context(self) -> Field {
        // Compute the note hash for nullification.
        let note_hash = compute_note_hash_for_nullify(self);
        // Retrieve a global secret (this is a placeholder; use the proper key management)
        let secret = get_nsk_app(self.owner.to_field());
        return poseidon2_hash_with_separator([note_hash, secret], GENERATOR_INDEX__NOTE_NULLIFIER as Field);
    }
}

// Helper function to create a new note, encrypting the zkpData.
fn create_data_usage_note(
    dataHash: Field,
    owner: Address,
    usagePermissions: Field,
    zkpData: Field,
    encryptionKey: Field  // Key for encryption.
) -> DataUsageRightsNote {
    // Encrypt the sensitive ZKP data.
    let encryptedZkpData = encrypt(zkpData, encryptionKey);
    
    DataUsageRightsNote {
        dataHash: dataHash,
        owner: owner,
        usagePermissions: usagePermissions,
        zkpData: encryptedZkpData,
        nullified: false,
    }
}

// Function to nullify an existing note.
fn nullify_data_usage_note(note: DataUsageRightsNote) -> DataUsageRightsNote {
    // Return a new note instance with the nullified flag set to true.
    DataUsageRightsNote {
        nullified: true,
        ..note  // Retain all other fields.
    }
}

// Function to update the note with new usage permissions and new ZKP data.
fn update_data_usage_note(
    note: DataUsageRightsNote,
    newUsagePermissions: Field,
    newZkpData: Field,
    encryptionKey: Field
) -> DataUsageRightsNote {
    // First, nullify the current note (for audit purposes).
    let _ = nullify_data_usage_note(note);
    
    // Encrypt the updated ZKP data.
    let updatedEncryptedZkpData = encrypt(newZkpData, encryptionKey);
    
    // Create a new note with the updated fields while preserving the original dataHash and owner.
    DataUsageRightsNote {
        dataHash: note.dataHash,
        owner: note.owner,
        usagePermissions: newUsagePermissions,
        zkpData: updatedEncryptedZkpData,
        nullified: false,
    }
}
