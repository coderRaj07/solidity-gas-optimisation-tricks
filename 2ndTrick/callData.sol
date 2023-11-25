// Bad: copying storage variable to memory
contract Bad {
    uint256[] public numbers; // a storage array

    function sumNumbers() public view returns (uint256 total) {
        total = sum(numbers); // costs 100 gas to copy numbers to memory
    }

    function sum(uint256[] memory _numbers) internal pure returns (uint256 total) {
        for (uint256 i = 0; i < _numbers.length; i++) {
            total += _numbers[i]; // costs 3 gas per iteration
        }
    }
}

// Good: using the calldata keyword
contract Good {
    uint256[] public numbers; // a storage array

    function sumNumbers() public view returns (uint256 total) {
        total = sum(numbers); // costs 3 gas to pass numbers as calldata
    }

    function sum(uint256[] calldata _numbers) internal pure returns (uint256 total) {
        for (uint256 i = 0; i < _numbers.length; i++) {
            total += _numbers[i]; // costs 2 gas per iteration
        }
    }
}
