// SPDX-License-Identifier:MIT
pragma solidity ^0.8.27;

import "./NerdFT.sol";
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
        uint32 createTime;
        ERC721 nft;
        bool isActive;
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

    constructor() {}

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
        ev.deadline = block.timestamp += _duration;
        ev.manager = msg.sender;
        ev.nft = ERC721(_nftAddress);
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
        ev.deadline = _deadline;

        // Trigger event updation event
        emit EventUpdated(msg.sender, _eventId, block.timestamp);
    }

    // End event registration
    function closeEvent() external {
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
    function registerForEvent(uint256 _eventId) external {
        // Perform sanity check
        _checkTxOrigin();

        // Check that event is valid and open
        _isValidEvent(_eventId);
        _isActiveEvent(_eventId);

        // Check user registration validity
        if (hasRegistered[msg.sender][_eventId]) {
            revent SenderAlreadyRegistered();
        }

        // Add user to event registration mapping
        hasRegistered[msg.sender][_eventId] = true;

        // Trigger user registration event
        emit UserRegistered(msg.sender, _eventId, block.timestamp);
    }

    function checkIntoEvent() external {
        // Perform checks
        _checkTxOrigin();
        _isValidEvent(_eventId);
        _isActiveEvent(_eventId);
    }

    function cancelRegistration() external {
        // Perform checks
        _checkTxOrigin();
        _isValidEvent(_eventId);
        _isActiveEvent(_eventId);
    }

    // ***  Read functions  *** //

    function getEvent(uint256 _eventId) external returns (Event memory) {
        // Perform checks
        _checkTxOrigin();
        _isValidEvent(_eventId);

        return events[_eventId];
    }

    function getAllEvents() external returns (Event[] memory) {
        // Perform sanity check
        _checkTxOrigin();
        return allEvents;
    }

    function getAllEventsCount() external returns (uint256) {
        // Perform sanity check
        _checkTxOrigin();
        return allEvents.length();
    }

    // ***  Private functions  *** //

    function _checkTxOrigin() internal pure {
        // if (msg.sender == address(0)) {
        //     revert AddressZeroDetected();
        // }

        require(msg.sender != address(0), AddressZeroDetected());
    }

    function _isValidEvent(uint256 _eventId) internal view {
        if (!events[_eventId]) {
            revert InvalidEventId();
        }
    }

    function _isOpenEvent(uint256 _eventId) internal view {
        if (block.timestamp >= events[_eventId].deadline) {
            revert EventRegistrationClosed();
        }
    }

    function _isActiveEvent(uint256 _eventId) internal view {
        if (!events[_eventId].isActive) {
            revert EventIsOver();
        }
    }

    function _isManager(uint256 _eventId) internal view {
        // if (events[_id].manager != msg.sender) {
        //     revert SenderNotManager();
        // }

        require(
            msg.sender == events[_eventId].manager,
            SenderNotManager("You are not event manager")
        );
    }
}
