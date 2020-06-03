pragma solidity ^0.4.26;


/***********************
 *                     *
 *      setten.io      *
 *                     *
 ***********************/

contract Notary {
    mapping(bytes32 => address) private signer;

    constructor() public payable {}

    /**
     * @dev fallback function, refusing any funds
     */
    function() external payable {
        revert("Not accepting payments");
    }

    /**
     * @dev sign a hash with the address of the sender
     * @param _hash hash to verify (md5 hash bytes in base64)
     */
    function sign(bytes32 _hash) external {
        require(signer[_hash] == address(0), "Hash already signed");
        signer[_hash] = msg.sender;
    }

    /**
     * @dev verify if the hash has been signed by someone
     * @param _hash hash to verify (md5 hash bytes in base64)
     * @return _signer address
     */
    function verify(bytes32 _hash) external view returns (address _signer) {
        return signer[_hash];
    }
}
