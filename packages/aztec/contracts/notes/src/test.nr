#[test]
fn test_data_usage_rights_note() {
    // Create a mock context for testing
    let mut context = PrivateContext::default();

    // Sample inputs
    let owner = Address::from(0x1234...);
    let dataHash = Field::from(1234567890);
    let usagePermissions = Field::from(1);  // Example permission value
    let zkpData: [u8; 32] = [0; 32];
    let encryption_key = Field::from(987654321);

    // Create the DataUsageRightsNote
    let note = create_data_usage_note(
        &mut context,
        owner,
        dataHash,
        usagePermissions,
        zkpData,
        encryption_key
    );

    // Verify initial permission
    let required_permission = Field::from(1);
    assert(verify_permission(note, required_permission));

    // Test updating permissions
    let new_permissions = Field::from(2);
    let updated_note = update_data_usage_note(
        &mut context,
        note,
        new_permissions,
        zkpData,
        encryption_key
    );
    
    // Verify the new permissions
    assert(verify_permission(updated_note, new_permissions));
}
