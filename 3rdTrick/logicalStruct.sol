// Example of using a struct to group variables that are logically related
struct Point {
    uint256 x; // 32 bytes
    uint256 y; // 32 bytes
    uint256 z; // 32 bytes
}

Point point1; // a storage variable of type Point
Point point2 = Point(1, 2, 3); // a memory variable of type Point initialized with values

// Example of using an array to group variables that are logically related
uint256[3] coordinates; // a storage array of 3 uint256 elements
coordinates[0] = 1; // assign values to the array elements
coordinates[1] = 2;
coordinates[2] = 3;

uint256[3] memory colors = [255, 0, 0]; // a memory array of 3 uint256 elements initialized with values
