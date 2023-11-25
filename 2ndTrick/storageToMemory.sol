// Bad: modifying storage variable directly
contract Bad {
    uint256[] public numbers; // a storage array

    function doubleNumbers() public {
        for (uint256 i = 0; i < numbers.length; i++) {
            numbers[i] *= 2; // costs 5000 gas per iteration
        }
    }
}

// Good: using the memory keyword
contract Good {
    uint256[] public numbers; // a storage array

    function doubleNumbers() public {
        uint256[] memory localNumbers = numbers; // costs 100 gas once
        for (uint256 i = 0; i < localNumbers.length; i++) {
            localNumbers[i] *= 2; // costs 3 gas per iteration
        }
        numbers = localNumbers; // costs 100 gas once
    }
}
