pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";
import "@chainlink/contracts/src/v0.8/ConfirmedOwner.sol";

contract LandOwnershipVerification is ChainlinkClient, ConfirmedOwner {
    bytes32 public constant LAND_OWNERSHIP_JOB_ID = "your_job_id";
    uint256 public constant ORACLE_PAYMENT = 0.1 * 10**18; // 0.1 LINK

    struct LandOwnership {
        string landParcelID;
        address owner;
        uint256 registrationDate;
    }

    mapping(string => LandOwnership) public landOwnershipRegistry;

    constructor() ConfirmedOwner(msg.sender) {
        setPublicChainlinkToken();
    }

    function verifyLandOwnership(string memory landParcelID) public onlyOwner {
        Chainlink.Request memory request = buildChainlinkRequest(
            LAND_OWNERSHIP_JOB_ID,
            address(this),
            this.fulfillLandOwnershipVerification.selector
        );

        request.add("landParcelID", landParcelID);

        sendChainlinkRequestTo(oracle, request, ORACLE_PAYMENT);
    }

    function fulfillLandOwnershipVerification(
        bytes32 _requestId,
        string memory _landParcelID,
        address _owner,
        uint256 _registrationDate
    ) public recordChainlinkFulfillment(_requestId) {
        LandOwnership memory ownership = LandOwnership({
            landParcelID: _landParcelID,
            owner: _owner,
            registrationDate: _registrationDate
        });

        landOwnershipRegistry[_landParcelID] = ownership;
    }
}
