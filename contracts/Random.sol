// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RandomNumberGenerator {
    // 存储随机数的映射，ID 到随机数
    mapping(uint256 => uint256) public randomNumbers;
    // 存储所有 ID 的数组
    uint256[] public allIds;
    // 当前的 ID
    uint256 public currentId = 1;

    // 生成随机数并保存
    function generateRandomNumber() external returns (uint256 id, uint256 random) {
        // 简单的随机数生成，实际应用中不建议这样做，可考虑使用预言机
        uint256 randomNum = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender)));
        randomNumbers[currentId] = randomNum;
        allIds.push(currentId);
        uint256 resultId = currentId;
        currentId++;
        return (resultId, randomNum);
    }

    // 通过 ID 查询随机数
    function getRandomNumberById(uint256 _id) external view returns (uint256) {
        return randomNumbers[_id];
    }

    // 获取所有 ID 和所有随机数
    function getAllIdsAndRandomNumbers() external view returns (uint256[] memory ids, uint256[] memory numbers) {
        uint256 length = allIds.length;
        uint256[] memory resultIds = new uint256[](length);
        uint256[] memory resultNumbers = new uint256[](length);
        for (uint256 i = 0; i < length; i++) {
            uint256 id = allIds[i];
            resultIds[i] = id;
            resultNumbers[i] = randomNumbers[id];
        }
        return (resultIds, resultNumbers);
    }
}