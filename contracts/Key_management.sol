// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract KeyManagementContract {
    address public owner;

    // 用户地址到ML - KEM公钥的映射
    mapping(address => bytes) public userPublicKey;
    // 存储所有用户地址的数组
    address[] public allUserAddresses;

    // 环签名公钥结构体（每个公钥由多个椭圆曲线点组成）
    struct ECPoint {
        uint256 x;
        uint256 y;
    }

    struct RingPublicKeyInfo {
        ECPoint[] points;  // 支持任意数量的点
        string description;
    }

    mapping(uint256 => RingPublicKeyInfo) public ringPublicKeyInfo;
    // 存储所有环签名公钥 ID 的数组
    uint256[] public allRingPublicKeyIds;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Unauthorized");
        _;
    }

    // 1. 存储用户公钥
    function storeUserPublicKey(address _userAddress, bytes memory _publicKey) external onlyOwner {
        if (userPublicKey[_userAddress].length == 0) {
            allUserAddresses.push(_userAddress);
        }
        userPublicKey[_userAddress] = _publicKey;
    }

    // 2. 存储环签名公钥
    function storeRingPublicKey(
        uint256 _publicKeyId,
        uint256[] memory _xCoordinates,
        uint256[] memory _yCoordinates,
        string memory _description
    ) external onlyOwner {
        require(_xCoordinates.length == _yCoordinates.length, "Coordinate mismatch");
        if (ringPublicKeyInfo[_publicKeyId].points.length == 0) {
            allRingPublicKeyIds.push(_publicKeyId);
        }
        RingPublicKeyInfo storage info = ringPublicKeyInfo[_publicKeyId];
        // 清空之前可能存在的点
        delete info.points;
        for (uint256 i = 0; i < _xCoordinates.length; i++) {
            info.points.push(ECPoint(_xCoordinates[i], _yCoordinates[i]));
        }
        info.description = _description;
    }

    // 3. 获取用户公钥
    function getUserPublicKey(address _userAddress) external view returns (bytes memory) {
        return userPublicKey[_userAddress];
    }

    // 4. 获取环签名公钥
    function getRingPublicKeyInfo(uint256 _publicKeyId) external view 
        returns (uint256[] memory, uint256[] memory, string memory) 
    {
        RingPublicKeyInfo storage info = ringPublicKeyInfo[_publicKeyId];
        uint256[] memory xCoords = new uint256[](info.points.length);
        uint256[] memory yCoords = new uint256[](info.points.length);
        for (uint256 i = 0; i < info.points.length; i++) {
            xCoords[i] = info.points[i].x;
            yCoords[i] = info.points[i].y;
        }
        return (xCoords, yCoords, info.description);
    }

    // 5. 获取所有用户及其公钥
    function getAllUserPublicKeys() external view returns (address[] memory, bytes[] memory) {
        address[] memory addresses = allUserAddresses;
        bytes[] memory publicKeys = new bytes[](addresses.length);
        for (uint256 i = 0; i < addresses.length; i++) {
            publicKeys[i] = userPublicKey[addresses[i]];
        }
        return (addresses, publicKeys);
    }

    // 6. 获取所有环签名公钥 ID、公钥和描述
    function getAllRingPublicKeyInfos() external view 
        returns (uint256[] memory, uint256[][] memory, uint256[][] memory, string[] memory) 
    {
        uint256[] memory ids = allRingPublicKeyIds;
        uint256[][] memory allXCoords = new uint256[][](ids.length);
        uint256[][] memory allYCoords = new uint256[][](ids.length);
        string[] memory descriptions = new string[](ids.length);

        for (uint256 i = 0; i < ids.length; i++) {
            uint256 publicKeyId = ids[i];
            RingPublicKeyInfo storage info = ringPublicKeyInfo[publicKeyId];
            uint256[] memory xCoords = new uint256[](info.points.length);
            uint256[] memory yCoords = new uint256[](info.points.length);
            for (uint256 j = 0; j < info.points.length; j++) {
                xCoords[j] = info.points[j].x;
                yCoords[j] = info.points[j].y;
            }
            allXCoords[i] = xCoords;
            allYCoords[i] = yCoords;
            descriptions[i] = info.description;
        }

        return (ids, allXCoords, allYCoords, descriptions);
    }
}