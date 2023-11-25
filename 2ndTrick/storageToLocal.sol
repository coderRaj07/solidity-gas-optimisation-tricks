// Bad: reading from storage multiple times
contract Bad {
    uint256 public counter; // a storage variable

    function increment() public {
        counter++; // costs 100 gas
        emit Incremented(counter); // costs 100 gas
        // do something else with counter
    }
}

// Good: assigning storage variable to a local variable
contract Good {
    uint256 public counter; // a storage variable

    function increment() public {
        uint256 localCounter = counter; // costs 100 gas once
        localCounter++; // costs 3 gas
        emit Incremented(localCounter); // costs 3 gas
        // do something else with localCounter
        counter = localCounter; // costs 100 gas once
    }
}

