// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0; // 버전

contract HelloWorld {
    string public message;

    // 배포될 때 자동으로 실행되는 함수
    constructor() {
        message = "Hello, World!"; // 변수 기본값 설정
    }

    function setMessage(string memory newMessage) public {
        message = newMessage;
    }

    function getMessage() public view returns (string memory) {
        return message;
    }
    
}
