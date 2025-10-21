// My First Noir Circuit - Signature Verification with ecrecover
// This simulates Ethereum's ecrecover function

// Helper: Convert 32 bytes to a Field number
fn bytes_to_field(bytes: [u8; 32]) -> Field {
    let mut result: Field = 0;
    for i in 0..32 {
        result = result * 256 + bytes[i] as Field;
    }
    result
}

// Helper: Convert 20 bytes (address) to a Field number
fn address_to_field(bytes: [u8; 20]) -> Field {
    let mut result: Field = 0;
    for i in 0..20 {
        result = result * 256 + bytes[i] as Field;
    }
    result
}

// Simplified ecrecover: combines pubkey + signature + message
// Returns an "address" (in real Ethereum, this would be keccak256(pubkey)[12:32])
fn ecrecover(
    pub_key_x: [u8; 32],
    pub_key_y: [u8; 32],
    signature: [u8; 65],
    hashed_message: [u8; 32]
) -> Field {
    // Convert inputs to Field numbers
    let x = bytes_to_field(pub_key_x);
    let y = bytes_to_field(pub_key_y);
    let msg = bytes_to_field(hashed_message);
    
    // Get signature r and s values
    let mut r_bytes: [u8; 32] = [0; 32];
    let mut s_bytes: [u8; 32] = [0; 32];
    for i in 0..32 {
        r_bytes[i] = signature[i];
        s_bytes[i] = signature[i + 32];
    }
    let r = bytes_to_field(r_bytes);
    let s = bytes_to_field(s_bytes);
    
    // Simple hash: just add everything together (super simplified!)
    // In real Ethereum: verify ECDSA, then hash pubkey to get address
    let combined = x + y + r + s + msg;
    
    combined
}

fn main(
    pub_key_x: [u8; 32],
    pub_key_y: [u8; 32],
    signature: [u8; 65],
    hashed_message: [u8; 32],
    expected_address: [u8; 20]
) -> pub Field {  //  Add this return type
    let recovered = ecrecover(pub_key_x, pub_key_y, signature, hashed_message);
    let expected = address_to_field(expected_address);
    
    assert(recovered != 0, "Recovered value must be non-zero");
    assert(expected != 0, "Expected address must be non-zero");
    
    recovered  //  Return the recovered value as public output
}