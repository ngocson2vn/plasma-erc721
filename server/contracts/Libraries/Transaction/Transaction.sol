pragma solidity ^0.4.24;

import "./RLP.sol";


library Transaction {

    using RLP for bytes;
    using RLP for RLP.RLPItem;

    struct TX {
        uint64 slot;
        address owner;
        bytes32 hash;
        uint256 prevBlock;
        uint256 denomination; 
    }

    function getTx(bytes memory txBytes) internal pure returns (TX memory) {
        RLP.RLPItem[] memory rlpTx = txBytes.toRLPItem().toList(4);
        TX memory transaction;

        transaction.slot = uint64(rlpTx[0].toUint());
        transaction.prevBlock = rlpTx[1].toUint();
        transaction.denomination = rlpTx[2].toUint();
        transaction.owner = rlpTx[3].toAddress();
        if (transaction.prevBlock == 0) { // deposit transaction
            transaction.hash = keccak256(abi.encodePacked(transaction.slot));
        } else {
            transaction.hash = keccak256(txBytes);
        }
        return transaction;
    }

    function getOwner(bytes memory txBytes) internal pure returns (address owner) {
        RLP.RLPItem[] memory rlpTx = txBytes.toRLPItem().toList(4);
        owner = rlpTx[3].toAddress();
    }
}
