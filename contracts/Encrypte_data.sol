// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EncryptedDataStorage {
    // 存储 AES 加密数据的映射，ID 到加密数据
    mapping(uint256 => bytes) public aesEncryptedData;
    // 存储 ML - KEM 加密数据的映射，ID 到加密数据
    mapping(uint256 => bytes) public mlKemEncryptedData;
    // 当前 AES 加密数据的 ID
    uint256 public currentAesId = 1;
    // 当前 ML - KEM 加密数据的 ID
    uint256 public currentMlKemId = 1;
    // 存储所有已存储的 AES 加密数据的 ID
    uint256[] public allAesIds;
    // 存储所有已存储的 ML - KEM 加密数据的 ID
    uint256[] public allMlKemIds;

    // 存储 AES 加密数据
    function storeAesEncryptedData(bytes memory _encryptedData) external returns (uint256 id) {
        aesEncryptedData[currentAesId] = _encryptedData;
        allAesIds.push(currentAesId);
        uint256 resultId = currentAesId;
        currentAesId++;
        return resultId;
    }

    // 存储 ML - KEM 加密数据
    function storeMlKemEncryptedData(bytes memory _encryptedData) external returns (uint256 id) {
        mlKemEncryptedData[currentMlKemId] = _encryptedData;
        allMlKemIds.push(currentMlKemId);
        uint256 resultId = currentMlKemId;
        currentMlKemId++;
        return resultId;
    }

    // 通过 ID 获取 AES 加密数据
    function getAesEncryptedData(uint256 _id) external view returns (bytes memory) {
        return aesEncryptedData[_id];
    }

    // 通过 ID 获取 ML - KEM 加密数据
    function getMlKemEncryptedData(uint256 _id) external view returns (bytes memory) {
        return mlKemEncryptedData[_id];
    }

    // 获取所有 AES 加密数据及其对应 ID
    function getAllAesEncryptedDataWithIds() external view returns (uint256[] memory ids, bytes[] memory data) {
        ids = allAesIds;
        data = new bytes[](ids.length);
        for (uint256 i = 0; i < ids.length; i++) {
            data[i] = aesEncryptedData[ids[i]];
        }
        return (ids, data);
    }

    // 获取所有 ML - KEM 加密数据及其对应 ID
    function getAllMlKemEncryptedDataWithIds() external view returns (uint256[] memory ids, bytes[] memory data) {
        ids = allMlKemIds;
        data = new bytes[](ids.length);
        for (uint256 i = 0; i < ids.length; i++) {
            data[i] = mlKemEncryptedData[ids[i]];
        }
        return (ids, data);
    }
}