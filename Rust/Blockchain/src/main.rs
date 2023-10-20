use std::time::{SystemTime, UNIX_EPOCH};
use sha2::{Sha256, Digest};
use hex;

#[derive(Debug)]
struct Block {
    index: usize, // Change the data type to usize
    timestamp: u64,
    data: String,
    previous_hash: String,
    hash: String,
}

impl Block {
    fn new(index: usize, data: String, previous_hash: String) -> Block {
        let timestamp = SystemTime::now().duration_since(UNIX_EPOCH).expect("Time went backwards").as_secs();
        let hash = Block::calculate_hash(index, &data, timestamp, &previous_hash);
        Block {
            index,
            timestamp,
            data,
            previous_hash,
            hash,
        }
    }

    fn calculate_hash(index: usize, data: &str, timestamp: u64, previous_hash: &str) -> String {
        let input = format!("{}{}{}{}", index, data, timestamp, previous_hash);
        let mut hasher = Sha256::new();
        hasher.update(input);
        hex::encode(hasher.finalize())
    }
}

fn main() {
    let mut blockchain: Vec<Block> = vec![];

    // Create the genesis block (the first block in the blockchain)
    let genesis_block = Block::new(0, "Genesis Block".to_string(), "0".to_string());
    blockchain.push(genesis_block);

    // Add some more blocks
    let mut previous_block = &blockchain[0];

    for i in 1..6 {
        let data = format!("Block #{}", i);
        let new_block = Block::new(i, data, previous_block.hash.clone());
        blockchain.push(new_block);
        previous_block = &blockchain[i];
    }

    // Print the blockchain
    for block in &blockchain {
        println!(
            "Block #{} - Hash: {} - Previous Hash: {}",
            block.index, block.hash, block.previous_hash
        );
    }
}
