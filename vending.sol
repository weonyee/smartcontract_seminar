// ETH이 없어서 구동은 못했음
// 자바 기반 워크스페이스로 전환하면 연습용 가상환경을 쓸 수 있다는데 방법을 찾지 못했음

// SPDX-License-Identifier: MIT License
pragma solidity >=0.7.0 <0.9.0; // 버전

contract VendingMachine {
    address owner; // owner 주소
    string[] itemList = ["Cider", "Juice", "Coke", "Water"];
    mapping(string => uint8) itemStock;

    // 스마트컨트랙트 외부에서 추적할 수 있도록 상태 변화 로그를 찍는 용도
    event SomeoneBuy(string itemName, uint8 stock);
    event SoldOut(string itemName);
    event AddItemStock(string itemName, uint8 stock);

    // 계약이 배포될 때 자동 실행
    constructor() {
        owner = msg.sender; // 배포자

        // 초기 수량 저장
        for (uint8 i = 0; i < itemList.length; i++) {
            itemStock[itemList[i]] = 10;
        }
    }

    // owner만 실행 가능한 함수 제한자
    modifier onlyOwner() {
        require(owner == msg.sender, "Only Owner!!");
        _;
    }

    // 구매할 때 실행되는 함수
    function buyItem(uint8 _index) public payable returns (string memory) {
        require(msg.value == 1 ether, "price 1 ETH per piece");

        if (itemStock[itemList[_index]] > 0) {
            // 1ETH 보내야만 구매 가능
            itemStock[itemList[_index]]--; // 재고 감소
            emit SomeoneBuy(itemList[_index], itemStock[itemList[_index]]); // 이벤트 발생
        } else if (itemStock[itemList[_index]] == 0) { // 품절
            emit SoldOut(itemList[_index]);
            revert("Sold Out"); // 트랜잭션 취소
        }

        return "Success!";
    }

    // 재고 추가
    function addStock(uint8 _index, uint8 _num)
        public
        onlyOwner // owner만 실행 가능
        returns (uint8 currentStock)
    {
        itemStock[itemList[_index]] += _num;
        currentStock = itemStock[itemList[_index]];

        emit AddItemStock(itemList[_index], currentStock);

        return currentStock;
    }

    // 이름과 재고 확인 함수
    function checkStock(uint8 _index)
        public
        view
        onlyOwner // owner만 실행 가능
        returns (string memory itemName, uint8 InStock)
    {
        itemName = itemList[_index];
        InStock = itemStock[itemList[_index]];
        return (itemName, InStock);
    }

    // ETH 잔액 확인
    function checkTotalBalance() public view onlyOwner returns (uint256) {
        return address(this).balance;
    }

    // ETH를 지갑으로 송금
    function withdrawBalance() public onlyOwner {
        (bool success, ) = payable(msg.sender).call{ // call 방식으로 전송
            value: address(this).balance
        }("");
        require(success, "Failed"); // 성공 여부 확인
    }
}
