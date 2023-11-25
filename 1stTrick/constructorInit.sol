// Bad: initializing storage variable to zero in the constructor
contract Bad {
    uint256 public totalSupply; // a storage variable

    constructor() public {
        totalSupply = 0; // costs more gas if totalSupply is increased later
    }

    function mint(uint256 _amount) public {
        totalSupply += _amount; // costs more gas if totalSupply was zero before
    }
}

// Good: initializing storage variable to a non-zero value in the constructor
contract Good {
    uint256 public totalSupply; // a storage variable

    constructor() public {
        totalSupply = 1000; // costs less gas if totalSupply is increased later
    }

    function mint(uint256 _amount) public {
        totalSupply += _amount; // costs less gas if totalSupply was non-zero before
    }
}
