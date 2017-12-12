pragma solidity ^0.4.17;

contract PrivateChannel {

    struct PEER {
        bool valid;
        bool endorser;
        string peerURL;
    }
    
    struct TX {
        bytes32 txHash;
    }
    
    uint peerCount;
    uint endorserCount;
    
    mapping(address => PEER) peers;
    mapping(bytes32 => boolean) chainCode;
    
    TX[] ledger;
    
    function PrivateChannel(string peerURL) {
        PEER storage p = peers[msg.sender];
        p.valid = true;
        p.endorser = true;
        p.url = peerURL;
        peerCount = 1;
        endorserCount = 1;
    }
    
    /**
     * Prüft ob alle Endorser den Fingerprint der Änderung signiert haben.
     */
    function checkEndorsement(bytes32 hash, uint8[] v, bytes32[] r, bytes32[] s) 
    constant internal returns (bool) {
        bytes32 h = keccak256(bytes32(uint(this)*uint(hash)));
        
        require(v.length == endorserCount);
        require(r.length == endorserCount);
        require(s.length == endorserCount);
        
        for(uint i = 0; i<endorserCount; i++) {
            address a = ecrecover(h, v[i], r[i], s[i]);
            
            // ....
            // require(all endorsers confirmed)
            // ...
        }
        
        return true;
    }
    
    /**
     * fügt einen Peer zu diesem Channel hinzu.
     * Die private Kommunikation mit dem Peer läuft über peerURL.
     * Die HTTP Requests dorthin müssen mit dem private key des Peers signiert sein.
     */
    function addPeer(address a, bool endorser, string peerURL) {
        // require check permissions
        // ...
    }
    
    function removePeer(address a) {
        // require check permissions
        // ...
    }
    
    /**
     * fügt eine Transaktion ein.
     * Permission Management kann separat definiert sein.
     * Alle Endorser müssen diese Transaktion für diese des PrivateChannel bestätigt haben.
     */
    function appendTransaction(bytes32 txHash, uint8[] v, bytes32[] r, bytes32[] s) {
        require(peers[msg.sender].valid);
        require(checkEndorsement(txHash, v, r, s));
        
        ledger.push(TX(txHash));
    }
 
    /**
     * Deployt ChainCode.
     * Eine konkrete Instanz wird über die Transaktion erzeugt.
     * Alle Endorser müssen den CodeHash für diese Instanz des PrivateChannel bestätigt haben.
     */
    function deployChainCode(bytes32 codeHash, uint8[] v, bytes32[] r, bytes32[] s) {
        require(peers[msg.sender].valid);
        // require check permissions...
        require(checkEndorsement(txHash, v, r, s));
        
        chainCode[codeHash] = true;
    }
    
}
