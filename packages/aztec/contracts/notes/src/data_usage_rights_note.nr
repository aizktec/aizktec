// packages/aztec/contracts/notes/data_usage_rights_note.nr
use dep::aztec::note::{
    note_header::NoteHeader,
    note_interface::{NoteInterface, destroy},
    utils::compute_note_hash_for_nullifier,
};
use dep::aztec::context::{PrivateContext, Context};
use dep::aztec::oracle::{get_public_key, get_nonce, get_nullifier};
use dep::aztec::hash::{poseidon2_hash_with_separator};
use dep::aztec::types::{
    Address, 
    aztec_address_to_field,
    GENERATOR_INDEX__NOTE_NULLIFIER,
};
use dep::aztec::protocol_types::constants::SERIALIZED_NOTE_HEADER_LEN;
use dep::aztec::protocol_types::nullifier_key::compute_nullifier_secret_key;
use dep::std::option::Option;

// DataUsageRightsNote structure
#[derive(Debug)]
struct DataUsageRightsNote {
    header: NoteHeader,
    owner: Address,          
    dataHash: Field,        
    usagePermissions: Field, 
    zkpData: [u8; 32],      
    nullified: bool,         
}

// Encryption utility functions
fn encrypt_data(data: [u8; 32], key: Field) -> [u8; 32] {

    let mut encrypted = [0; 32];
    for i in 0..32 {

        let key_byte = (key & (0xFF << (i * 8))) >> (i * 8);
        encrypted[i] = data[i] ^ key_byte as u8;
    }
    encrypted
}

fn decrypt_data(encrypted_data: [u8; 32], key: Field) -> [u8; 32] {

    encrypt_data(encrypted_data, key)
}

// NoteInterface trait for DataUsageRightsNote
impl NoteInterface for DataUsageRightsNote {
    fn serialize(self) -> [Field; SERIALIZED_NOTE_HEADER_LEN] {

        let mut serialized = [0; SERIALIZED_NOTE_HEADER_LEN];
        
        
        let header_fields = self.header.serialize();
        for i in 0..header_fields.len() {
            serialized[i] = header_fields[i];
        }
        

        let owner_field = aztec_address_to_field(self.owner);
        serialized[5] = owner_field;
        serialized[6] = self.dataHash;
        serialized[7] = self.usagePermissions;
        

        let mut zkp_field = 0;
        for i in 0..32 {
            zkp_field += (self.zkpData[i] as Field) << (i * 8);
        }
        serialized[8] = zkp_field;
        

        serialized[9] = if self.nullified { 1 } else { 0 };
        
        serialized
    }

    fn deserialize(serialized: [Field; SERIALIZED_NOTE_HEADER_LEN]) -> Self {
        let header = NoteHeader::deserialize(serialized);
        
        let owner = Address::from_field(serialized[5]);
        let dataHash = serialized[6];
        let usagePermissions = serialized[7];
        
    
        let zkp_field = serialized[8];
        let mut zkpData = [0; 32];
        for i in 0..32 {
            zkpData[i] = ((zkp_field >> (i * 8)) & 0xFF) as u8;
        }
        
        let nullified = serialized[9] == 1;
        
        DataUsageRightsNote {
            header,
            owner,
            dataHash,
            usagePermissions,
            zkpData,
            nullified,
        }
    }

    fn compute_nullifier(self, context: &mut PrivateContext) -> Field {
  
        let note_hash = compute_note_hash_for_nullifier(self);
        let nullifier_key = compute_nullifier_secret_key(self.owner);
        

        poseidon2_hash_with_separator(
            [note_hash, nullifier_key], 
            GENERATOR_INDEX__NOTE_NULLIFIER
        )
    }
    
    fn get_header(self) -> NoteHeader {
        self.header
    }
}

fn create_data_usage_note(
    context: &mut PrivateContext,
    owner: Address,
    dataHash: Field,
    usagePermissions: Field,
    zkpData: [u8; 32],
    encryption_key: Field
) -> DataUsageRightsNote {

    let header = NoteHeader::new(context);
    

    let encrypted_zkp_data = encrypt_data(zkpData, encryption_key);
    

    DataUsageRightsNote {
        header,
        owner,
        dataHash,
        usagePermissions,
        zkpData: encrypted_zkp_data,
        nullified: false,
    }
}


fn update_data_usage_note(
    context: &mut PrivateContext,
    note: DataUsageRightsNote,
    new_permissions: Field,
    new_zkp_data: [u8; 32],
    encryption_key: Field
) -> DataUsageRightsNote {
   
    let nullified_note = DataUsageRightsNote {
        nullified: true,
        ..note  
    };
    

    let nullifier = nullified_note.compute_nullifier(context);
    context.notify_nullifier_storage(nullifier);
    

    let encrypted_zkp_data = encrypt_data(new_zkp_data, encryption_key);
    
    let header = NoteHeader::new(context);
    
    DataUsageRightsNote {
        header,
        owner: nullified_note.owner,
        dataHash: nullified_note.dataHash,
        usagePermissions: new_permissions,
        zkpData: encrypted_zkp_data,
        nullified: false,
    }
}

// Function to transfer ownership of the data usage rights
fn transfer_data_usage_rights(
    context: &mut PrivateContext,
    note: DataUsageRightsNote,
    new_owner: Address
) -> DataUsageRightsNote {

    let nullified_note = DataUsageRightsNote {
        nullified: true,
        ..note
    };
    

    let nullifier = nullified_note.compute_nullifier(context);
    context.notify_nullifier_storage(nullifier);
    

    let header = NoteHeader::new(context);
    

    DataUsageRightsNote {
        header,
        owner: new_owner,
        dataHash: nullified_note.dataHash,
        usagePermissions: nullified_note.usagePermissions,
        zkpData: nullified_note.zkpData,
        nullified: false,
    }
}


fn verify_permission(
    note: DataUsageRightsNote,
    required_permission: Field
) -> bool {
 
    if note.nullified {
        return false;
    }
    
    (note.usagePermissions & required_permission) == required_permission
}