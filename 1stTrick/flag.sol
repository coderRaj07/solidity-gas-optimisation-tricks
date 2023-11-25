// Bad: zero to one storage write
contract Bad {
    uint256 public x;

    function setX(uint256 _x) public {
        x = _x; // costs more gas if x was zero before
    }
}

// Good: avoid zero to one storage write with a flag
contract Good {
    uint256 public x;
    bool public isXSet; // flag variable

    function setX(uint256 _x) public {
        if (!isXSet) {
            isXSet = true; // only do this once
        }
        x = _x; // costs less gas if isXSet is true
    }
}
