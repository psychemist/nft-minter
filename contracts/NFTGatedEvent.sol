// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import "./CustomNFT.sol";
import "./NFTGatedEventHelpers.sol";

contract NFTGatedEvent is NFTGatedEventHelpers {
    // Storage variables
    uint256 public eventCount;

    // Structs
    struct Event {
        uint256 id;
        string name;
        string venue;
        address manager;
        uint32 registrations;
        uint32 attendees;
        uint32 deadline;
        bool isActive;
        CustomNFT nft;
    }
    Event[] allEvents;

    // Keep ANON!
    // struct User {
    //     string pseudonym;
    // }

    // Mappings
    mapping(uint256 => Event) events;
    // user address -> event id -> has registered check
    mapping(address => mapping(uint256 => bool)) hasRegistered;
    // user address -> event id -> is attending check
    mapping(address => mapping(uint256 => bool)) isAttending;

    // ***  Write functions  *** //

    // Create event
    function createEvent(
        address _nftAddress,
        string memory _name,
        string memory _venue,
        uint32 _duration
    ) external {
        // Perform sanity check
        _checkTxOrigin();

        // Create Event struct in memory
        Event memory ev;

        // Update event count
        eventCount += 1;
        uint256 eventCounter = eventCount;
        ev.id = eventCounter;

        // Update other event properties
        ev.name = _name;
        ev.venue = _venue;
        ev.deadline = uint32(block.timestamp) + _duration;
        ev.manager = msg.sender;
        ev.nft = CustomNFT(_nftAddress);
        ev.isActive = true;

        // Add new event to events mappings
        events[eventCounter] = ev;
        allEvents.push(ev);

        // Trigger event creation event
        emit EventCreated(msg.sender, eventCounter, block.timestamp);
    }

    // Update event
    function updateEvent(
        uint256 _eventId,
        string memory _name,
        string memory _venue,
        uint32 _extension
    ) external {
        // Perform sanity check
        _checkTxOrigin();

        // Verify that event is a valid event
        _isValidEvent(_eventId);

        // Verify that event registration is still open
        _isOpenEvent(_eventId);

        // Verify that event is still active
        _isActiveEvent(_eventId);

        // Verify that transaction sender is event manager
        _isManager(_eventId);

        // Read Event struct from storage
        Event storage ev = events[_eventId];

        // Update event properties
        ev.name = _name;
        ev.venue = _venue;
        ev.deadline += _extension;

        // Update event in events array
        allEvents[_eventId - 1] = ev;

        // Trigger event updation event
        emit EventUpdated(msg.sender, _eventId, block.timestamp);
    }

    // End event registration
    function closeEvent(uint256 _eventId) external {
        // Perform checks
        _checkTxOrigin();
        _isValidEvent(_eventId);
        _isActiveEvent(_eventId);
        _isManager(_eventId);

        // Read Event struct from storage
        Event storage ev = events[_eventId];

        // Flip event boolean property to close registrations
        ev.isActive = false;

        // Trigger event closure event
        emit EventClosed(msg.sender, _eventId, block.timestamp);
    }

    // Register user for event
    function registerForEvent(uint256 _eventId, uint256 _nftId) external {
        // Perform sanity check
        _checkTxOrigin();

        // Check that event is valid and open
        _isValidEvent(_eventId);
        _isActiveEvent(_eventId);

        // Check user registration validity
        if (hasRegistered[msg.sender][_eventId]) {
            revert SenderAlreadyRegistered();
        }

        // Read Event struct from storage
        Event storage ev = events[_eventId];

        // Check that user has event NFT in their account
        require(ev.nft.balanceOf(msg.sender) > 0, NFTNotDetected());

        // Check that user has event NFT and is the owner
        require(ev.nft.ownerOf(_nftId) == msg.sender, NFTNotDetected());

        // Increase event registrations
        ev.registrations += 1;

        // Add user to event registration mapping
        hasRegistered[msg.sender][_eventId] = true;

        // Trigger user registration event
        emit UserRegistered(msg.sender, _eventId);
    }

    // Check user into event
    function checkIntoEvent(uint256 _eventId) external {
        // Perform checks
        _checkTxOrigin();
        _isValidEvent(_eventId);
        _isActiveEvent(_eventId);
        _isOpenEvent(_eventId);

        // Check user registration validity
        if (!hasRegistered[msg.sender][_eventId]) {
            revert SenderNotRegistered();
        }

        // Check that user is attending event
        if (isAttending[msg.sender][_eventId]) {
            revert SenderAlreadyAttending();
        }

        // Read Event struct from storage
        Event storage ev = events[_eventId];

        // Increase event registrations
        ev.attendees += 1;

        // Add user to event attendance mapping
        isAttending[msg.sender][_eventId] = true;

        // Trigger user checked-in event
        emit UserCheckedIn(msg.sender, _eventId);
    }

    // Cancel attendance for user from event
    function cancelRSVP(uint256 _eventId) external {
        // Perform checks
        _checkTxOrigin();
        _isValidEvent(_eventId);
        _isActiveEvent(_eventId);
        _isOpenEvent(_eventId);

        // Check user registration validity
        if (!hasRegistered[msg.sender][_eventId]) {
            revert SenderNotRegistered();
        }

        // Check user attendance validity
        if (!isAttending[msg.sender][_eventId]) {
            revert SenderNotAttending();
        }

        // Read Event struct from storage
        Event storage ev = events[_eventId];

        // Increase event registrations
        ev.attendees -= 1;

        // Remove user from event attendance mappings
        isAttending[msg.sender][_eventId] = false;

        // Trigger user canceled event
        emit UserCanceled(msg.sender, _eventId);
    }

    // ***  Read functions  *** //

    // Get event with id
    function getEvent(uint256 _eventId) external view returns (Event memory) {
        // Perform checks
        _checkTxOrigin();
        _isValidEvent(_eventId);

        return events[_eventId];
    }

    // Get all events array
    function getAllEvents() external view returns (Event[] memory) {
        // Perform sanity check
        _checkTxOrigin();
        return allEvents;
    }

    // Get all events array count
    function getAllEventsCount() external view returns (uint256) {
        // Perform sanity check
        _checkTxOrigin();
        return allEvents.length;
    }

    // ***  Private functions  *** //

    // Check that transaction origin is not zero address
    function _checkTxOrigin() internal view {
        // if (msg.sender == address(0)) {
        //     revert AddressZeroDetected();
        // }

        require(msg.sender != address(0), AddressZeroDetected());
    }

    // Check that event has been created
    function _isValidEvent(uint256 _eventId) internal view {
        if (events[_eventId].id <= 0) {
            revert InvalidEventId();
        }

        if (_eventId > allEvents.length) {
            revert InvalidEventId();
        }
    }

    // Check that event registration is still open
    function _isOpenEvent(uint256 _eventId) internal view {
        if (block.timestamp >= events[_eventId].deadline) {
            revert EventRegistrationClosed();
        }
    }

    // Check that event is still active/live
    function _isActiveEvent(uint256 _eventId) internal view {
        if (!events[_eventId].isActive) {
            revert EventIsOver();
        }
    }

    // Check that transaction origin is event manager
    function _isManager(uint256 _eventId) internal view {
        // if (events[_id].manager != msg.sender) {
        //     revert SenderNotManager();
        // }

        require(msg.sender == events[_eventId].manager, SenderNotManager());
    }
}
