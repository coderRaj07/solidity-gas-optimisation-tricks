// Bad: using an array
contract Bad {
    uint256[] public balances; // an array of balances

    function setBalance(uint256 _index, uint256 _amount) public {
        balances[_index] = _amount; // costs more gas if the array has empty slots
    }
}

// Good: using a mapping
contract Good {
    mapping(uint256 => uint256) public balances; // a mapping of balances

    function setBalance(uint256 _index, uint256 _amount) public {
        balances[_index] = _amount; // costs less gas if the keys are sparse
    }
}
