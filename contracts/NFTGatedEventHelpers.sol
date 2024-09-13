// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract NFTGatedEventHelpers {
    // Custom Errors
    error AddressZeroDetected();
    error EventIsOver();
    error EventRegistrationClosed();
    error InvalidEventId();
    error NFTNotDetected();
    error SenderAlreadyAttending();
    error SenderAlreadyRegistered();
    error SenderNotAttending();
    error SenderNotManager();
    error SenderNotRegistered();

    // Events
    event EventCreated(
        address indexed creator,
        uint256 indexed eventId,
        uint256 currentTime
    );
    event EventUpdated(
        address indexed creator,
        uint256 indexed eventId,
        uint256 currentTime
    );
    event EventClosed(
        address indexed creator,
        uint256 indexed eventId,
        uint256 currentTime
    );
    event UserRegistered(address indexed attendee, uint256 indexed eventId);
    event UserCheckedIn(address indexed attendee, uint256 indexed eventId);
    event UserCanceled(address indexed attendee, uint256 indexed eventId);
}
