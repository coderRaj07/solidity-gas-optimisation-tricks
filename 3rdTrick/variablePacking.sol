// Bad: variables are not packed
contract Bad {
    bool active; // 1 byte
    uint256 id; // 32 bytes
    address owner; // 20 bytes
    uint8 status; // 1 byte
    // total size: 54 bytes => 2 slots => 512 bits
}

// Good: variables are packed
contract Good {
    uint256 id; // 32 bytes
    address owner; // 20 bytes
    uint8 status; // 1 byte
    bool active; // 1 byte
    // total size: 54 bytes => 1 slot => 256 bits
}

// Bad: struct is not packed
struct Bad {
    uint256 x; // 32 bytes
    uint8 y; // 1 byte
    uint256 z; // 32 bytes
    // total size: 65 bytes => 3 slots => 768 bits
}

// Good: struct is packed
struct Good {
    uint256 x; // 32 bytes
    uint256 z; // 32 bytes
    uint8 y; // 1 byte
    // total size: 65 bytes => 2 slots => 512 bits
}
