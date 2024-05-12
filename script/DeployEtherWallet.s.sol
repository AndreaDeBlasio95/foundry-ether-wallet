// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Script.sol";
import "../src/EtherWallet.sol";

contract DeployEtherWallet is Script {
    function run() external {
        vm.startBroadcast();

        EtherWallet etherWallet = new EtherWallet();
        console.log("Deployed EtherWallet at:", address(etherWallet));

        vm.stopBroadcast();
    }
}
