#!/bin/bash

input_file="inputs.txt"
output_file="Prover.toml"

# Extract value inside quotes, trim spaces and remove Windows line endings
extract_value() {
    local key=$1
    grep -E "^\s*$key\s*=" "$input_file" | sed -E 's/^[^=]+=[[:space:]]*"(.*)"/\1/' | tr -d '\r' | xargs
}

# Convert hex string (without 0x) to decimal array
hex_to_dec_array() {
    local hexstr=$1
    local len=${#hexstr}
    local arr=()
    for (( i=0; i<len; i+=2 )); do
        hexbyte="${hexstr:i:2}"
        if ! [[ "$hexbyte" =~ ^[0-9a-fA-F]{2}$ ]]; then
            echo "Invalid hex byte: $hexbyte" >&2
            exit 1
        fi
        arr+=($((16#$hexbyte)))
    done
    echo "["$(IFS=,; echo "${arr[*]}")"]"
}

# Read values
expected_address=$(extract_value expected_address)
hashed_message=$(extract_value hashed_message)
pub_key_x=$(extract_value pub_key_x)
pub_key_y=$(extract_value pub_key_y)
signature=$(extract_value signature)

# Debug: check extracted values
echo "DEBUG expected_address: '$expected_address'"
echo "DEBUG hashed_message: '$hashed_message'"
echo "DEBUG pub_key_x: '$pub_key_x'"
echo "DEBUG pub_key_y: '$pub_key_y'"
echo "DEBUG signature: '$signature'"

# Convert expected_address to decimal array (20 bytes for Ethereum address)
expected_address=${expected_address#0x}
expected_address_arr=$(hex_to_dec_array "$expected_address")

# Remove 0x from hex fields if present
hashed_message=${hashed_message#0x}
pub_key_x=${pub_key_x#0x}
pub_key_y=${pub_key_y#0x}
signature=${signature#0x}

# Convert hex strings to decimal arrays
hashed_message_arr=$(hex_to_dec_array "$hashed_message")
pub_key_x_arr=$(hex_to_dec_array "$pub_key_x")
pub_key_y_arr=$(hex_to_dec_array "$pub_key_y")
signature_arr=$(hex_to_dec_array "$signature")

# Write Prover.toml
cat > "$output_file" <<EOF
expected_address = $expected_address_arr
hashed_message = $hashed_message_arr
pub_key_x = $pub_key_x_arr
pub_key_y = $pub_key_y_arr
signature = $signature_arr
EOF

echo "Wrote $output_file successfully!"