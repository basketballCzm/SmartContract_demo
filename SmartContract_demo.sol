pragma solidity ^0.4.21;
//源代码版本
contract SmartContract_demo{
    //公共变量被声明时自动创建set和get函数
    address public minter;

    //hash表 相当于一个key-value的键值对，默认创建get函数
    mapping (address => uint) public balances;
    
    // 它会在 send 函数的最后一行被发出。 用户界面(当然也包括服务器应用程序)
    //可以监听区块链上正在发送的事件，而不会花费太多成本。
    //可能是界面层次需要该信号做一些现实功能
    event Sent(address from, address to, uint amount);
    
    //msg是一个特别的全局变量，其中包含一些允许访问区块链的属性
    function SmartContract_demo(uint initialSupply) public{
        minter = msg.sender;
        balances[msg.sender] = initialSupply;
    }
    
    //msg.sender始终是当前外部函数调用的来源地址，
    //也就是该函数只能被合约创建者调用
    function mint(address receiver, uint amount) public {
        if(msg.sender != minter) return ;
        balances[receiver] += amount;
    }
    
    //最后的监听事件创建的原因是:
    /*实际上你发送的币和更改余额的信息仅仅存储在特定合约的数据存储中。
    通过使用事件可以为你的新币创建一个"浏览器"来追踪交易和余额。*/
    function send(address receiver, uint amount) public {
        if(balances[msg.sender] < amount) return;
        balances[msg.sender] -= amount;
        balances[receiver] += amount;
        emit Sent(msg.sender, receiver, amount);
    }
}

/*
//接收监听事件
SmartContract_demo.Sent().watch({},'',function(error,result){
    if(!error){
        console.log("Coin transfer: "+result.args.amount+"coin was sent from: "+result.args.from+"to: "+result.args.to+".");
        console.log("balances now:\n"+"sender: "+SmartContract_demo.balances.call(result.args.from)+"Receiver: "+SmartContract_demo.balances.call(result.args.to));
        
    }
})*/