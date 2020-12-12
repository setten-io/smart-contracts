pragma solidity ^0.6.6;
pragma experimental ABIEncoderV2;

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
    struct Signature {
        address signer;
        uint256 date;
        uint256 block;
    }

    uint256 public fee;
    mapping(string => Signature) private hash_signature;
    mapping(address => Signature[]) private signer_signatures;

    /**
     * @param _fee price to pay for a signature in wei
     */
    constructor(uint256 _fee) public {
        fee = _fee;
    }

    /**
     * @dev fallback function, refusing any funds
     */
    fallback() external payable {
        revert("Not accepting payments");
    }

    receive() external payable {
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
    function sign(string calldata _hash) external payable {
        require(
            hash_signature[_hash].signer == address(0),
            "Hash already signed"
        );
        require(msg.value >= fee, "Not enough fee");
        Signature memory signature = Signature(
            msg.sender,
            block.timestamp,
            block.number
        );
        hash_signature[_hash] = signature;
        signer_signatures[msg.sender].push(signature);
    }

    /**
     * @dev verify if the hash has been signed by someone
     * @param _hash hash to verify (md5 hash bytes in base64)
     * @return _signature
     */
    function verify(string calldata _hash)
        external
        view
        returns (Signature memory _signature)
    {
        return hash_signature[_hash];
    }

    /**
     * @dev return all signed hashes from an address
     * @param _signer address of the signer
     * @return _signatures
     */
    function signatures(address _signer)
        external
        view
        returns (Signature[] memory _signatures)
    {
        return signer_signatures[_signer];
    }
}
