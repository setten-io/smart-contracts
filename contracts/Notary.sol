pragma solidity ^0.4.26;

/***********************
 *       OWNABLE       *
 ***********************/
contract Ownable {
    address public owner;

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        if (msg.sender == owner) _;
    }

    function transferOwnership(address _newOwner) external onlyOwner {
        if (_newOwner != address(0)) owner = _newOwner;
    }
}

/***********************
 *      setten.io      *
 *       NOTARY        *
 ***********************/
contract Notary is Ownable {
    uint256 public fee;
    mapping(bytes32 => address) private signer;

    /**
     * @param _fee price to pay for a signature in wei
     */
    constructor(uint256 _fee) public {
        fee = _fee;
    }

    /**
     * @dev fallback function, refusing any funds
     */
    function() external payable {
        revert("Not accepting payments");
    }

    /**
     * @dev change the siginig fee
     * @param _fee price to pay for a signature in wei
     */
    function updateFee(uint256 _fee) external onlyOwner {
        fee = _fee;
    }

    /**
     * @dev withdraw signing fees
     */
    function withdraw() external onlyOwner {
        msg.sender.transfer(address(this).balance);
    }

    /**
     * @dev sign a hash with the address of the sender
     * @param _hash hash to verify (md5 hash bytes in base64)
     */
    function sign(bytes32 _hash) external payable {
        require(signer[_hash] == address(0), "Hash already signed");
        require(msg.value >= fee, "Not enough fee");
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
