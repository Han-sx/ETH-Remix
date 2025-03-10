// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SignatureStorage {
    // 定义存储签名信息的结构体
    struct SignatureInfo {
        bytes message;
        bytes signature;
        bytes ringPublicKey;
    }

    // 存储 ID 到签名信息的映射
    mapping(uint256 => SignatureInfo) public signatureInfos;
    // 存储所有的 ID
    uint256[] public allIds;
    // 当前可用的 ID
    uint256 public currentId = 1;

    // 存储签名信息的函数
    function storeSignature(
        bytes memory _message,
        bytes memory _signature,
        bytes memory _ringPublicKey
    ) external returns (uint256) {
        signatureInfos[currentId] = SignatureInfo(_message, _signature, _ringPublicKey);
        allIds.push(currentId);
        uint256 assignedId = currentId;
        currentId++;
        return assignedId;
    }

    // 通过 ID 查询签名信息的函数
    function getSignatureById(uint256 _id) external view returns (bytes memory, bytes memory, bytes memory) {
        SignatureInfo memory info = signatureInfos[_id];
        return (info.message, info.signature, info.ringPublicKey);
    }

    // 获取所有签名信息的函数
    function getAllSignatures() external view returns (
        uint256[] memory,
        bytes[] memory,
        bytes[] memory,
        bytes[] memory
    ) {
        uint256 length = allIds.length;
        uint256[] memory ids = new uint256[](length);
        bytes[] memory messages = new bytes[](length);
        bytes[] memory signatures = new bytes[](length);
        bytes[] memory ringPublicKeys = new bytes[](length);

        for (uint256 i = 0; i < length; i++) {
            uint256 id = allIds[i];
            ids[i] = id;
            SignatureInfo memory info = signatureInfos[id];
            messages[i] = info.message;
            signatures[i] = info.signature;
            ringPublicKeys[i] = info.ringPublicKey;
        }

        return (ids, messages, signatures, ringPublicKeys);
    }
}