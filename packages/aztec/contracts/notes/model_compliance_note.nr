use dep::aztec::{
    macros::{aztec, notes::note, storage::storage},
    oracle::random::random,
    protocol_types::address::AztecAddress,
    prelude::{PrivateContext, PrivateSet, Map, PublicContext, NoteGetterOptions, NoteViewerOptions},
    encrypted_logs::log_assembly_strategies::default_aes128::note::encode_and_encrypt_note,
    utils::comparison::Comparator,
};

#[aztec]
pub contract ModelCompliance {
    #[note]
    #[derive(Eq)]
    pub struct ModelComplianceNote {
        modelHash: Field,
        complianceType: Field,
        proof: Field[32],
        owner: AztecAddress,
        randomness: Field,
    }

    impl ModelComplianceNote {
        pub fn new(modelHash: Field, complianceType: Field, proof: Field[32], owner: AztecAddress) -> Self {
            let randomness = unsafe { random() };
            ModelComplianceNote { modelHash, complianceType, proof, owner, randomness }
        }
    }

    #[storage]
    struct Storage<Context> {
        admin: AztecAddress,
        compliance_notes: Map<AztecAddress, PrivateSet<ModelComplianceNote, Context>, Context>,
    }

    #[public]
    #[initializer]
    fn constructor(admin: AztecAddress) {
        assert(!admin.is_zero(), "invalid admin");
        storage.admin = admin;
    }

    #[private]
    fn certify_model(modelHash: Field, complianceType: Field, proof: Field[32], owner: AztecAddress) {
        assert(context.msg_sender().eq(storage.admin), "only admin can certify");
        let existing_notes = storage.compliance_notes.at(owner).view_notes(NoteViewerOptions::new()
            .select(ModelComplianceNote::properties().modelHash, Comparator.EQ, modelHash)
            .set_limit(1));
        assert(existing_notes.len() == 0, "model already certified");

        let note = ModelComplianceNote::new(modelHash, complianceType, proof, owner);
        let sender = context.msg_sender();
        storage.compliance_notes.at(owner).insert(note).emit(encode_and_encrypt_note(
            &mut context,
            owner,
            sender
        ));
    }

    #[private]
    fn update_compliance(modelHash: Field, new_complianceType: Field, new_proof: Field[32]) {
        let owner = context.msg_sender();
        let notes = storage.compliance_notes.at(owner).pop_notes(NoteGetterOptions::new()
            .select(ModelComplianceNote::properties().modelHash, Comparator.EQ, modelHash)
            .set_limit(1));
        assert(notes.len() == 1, "note not found");
        let old_note = notes.get_unchecked(0);
        let nullifier = hash([old_note.modelHash, old_note.randomness]);
        context.push_nullifier(nullifier);

        let new_note = ModelComplianceNote::new(modelHash, new_complianceType, new_proof, owner);
        storage.compliance_notes.at(owner).insert(new_note).emit(encode_and_encrypt_note(
            &mut context,
            owner,
            context.msg_sender()
        ));
    }

    #[private]
    fn nullify_compliance(modelHash: Field) {
        let owner = context.msg_sender();
        let notes = storage.compliance_notes.at(owner).pop_notes(NoteGetterOptions::new()
            .select(ModelComplianceNote::properties().modelHash, Comparator.EQ, modelHash)
            .set_limit(1));
        assert(notes.len() == 1, "note not found");
        let note = notes.get_unchecked(0);
        let nullifier = hash([note.modelHash, note.randomness]);
        context.push_nullifier(nullifier);
    }

    unconstrained fn view_compliance(owner: AztecAddress, modelHash: Field) -> pub bool {
        let notes = storage.compliance_notes.at(owner).view_notes(NoteViewerOptions::new()
            .select(ModelComplianceNote::properties().modelHash, Comparator.EQ, modelHash)
            .set_limit(1));
        notes.len() == 1
    }
}