# ecrecover-dsa in Noir

## Description

`ecrecover-dsa` is a Zero-Knowledge (ZK) circuit in **Noir** that proves ownership of an Ethereum address using a signature **without revealing your private key**.  

- **Proving** → “I own this Ethereum address / I created this signature.”  
- **Hiding** → Private key, signature, and optionally the message.  

It recomputes the address from the public key, signature, and message, and asserts it matches the expected address. If correct, the assertion passes; nothing is output.

---

## Why Use It

- **Privacy-preserving identity**: Prove Ethereum address ownership without revealing your private key.  
- **Authentication without secrets**: Verify signed messages without exposing the key.  
- **Proof of authority**: Show control over a key/address in ZK form (e.g., zk-rollups, private voting).  

---

## Usage



```bash

3. Create and populate Prover.toml
bash
Copy code
nargo check
Fill in your inputs in Prover.toml.

4. Generate Inputs
Hash your message:

bash
Copy code
cast keccak "hello"
Sign the message:

bash
Copy code
cast wallet sign --no-hash --account <keystore-name> <bytes-output>
Get your public key:

bash
Copy code
cast wallet public-key --account <keystore-name>
Populate inputs.txt:

toml
Copy code
expectedAddress = "0x52d64ED1fd0877797e2030fc914259e052F2bD67"
hashed_message = "0x1c8aff950685c2ed4bc3174f3472287b56d9517b9c948127319a09a7a36deac8"
pub_key_x = "533367042c3e9456fec155940165c28c01fe6e28601337df50562ddc4f36bfb9"
pub_key_y = "7dcafe27cadbe10861bb67e0599382f79dc29c1d39d93b10f716c8ceff1743ed"
signature = "0xdd935f778351217ec02e6f857e47f0cea837380f30eccf63742b9a97cf1872b4316700b028504591f6b31203b86ccb3363353eedd8f9cf4f344a769c689525b31b"
Run input generator:

bash
Copy code
chmod +x generate_inputs.sh
./generate_inputs.sh
5. Compile Circuit (Optional)
bash
Copy code
nargo compile
6. Execute Circuit & Generate Witness
bash
Copy code
nargo execute
7. Create Proof
bash
Copy code
bb prove -b ./target/circuits.json -w ./target/circuits.gz -o ./target
bb prove --oracle_hash keccak -b ./target/circuits.json -w ./target/circuits.gz -o ./target
8. Verification Key
Off-chain:

bash
Copy code
bb write_vk -b ./target/circuits.json -o ./target
On-chain verifier:

bash
Copy code
bb write_vk --oracle_hash keccak -b ./target/circuits.json -o ./target
9. Verification
Off-chain:

bash
Copy code
bb verify -k ./target/vk -p ./target/proof
Generate Solidity verifier:

bash
Copy code
bb write_solidity_verifier -k ./target/vk -o ./target/Verifier.sol
