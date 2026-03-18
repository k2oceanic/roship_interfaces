# Relay Interfaces

ROS2 message definitions for relay board control systems. This package provides standardized interfaces for binary, proportional, and trip-protected relays commonly used in marine robotic platforms.

## Message Types

### Relay.msg

Core message representing a single relay channel command.

```
uint8   node_id         # Target node ID (stack position)
int32   channel         # Target channel ID

bool    powered         # Relay on/off (true = energize, false = de-energize)
float32 setpoint        # Setpoint value for proportional relays (0.0 to 1.0)
bool    trip_reset      # Trip reset (true = reset trip, false = no action)
```

### RelayStamped.msg

Time-stamped single relay command, suitable for control loops requiring precise timing.

```
std_msgs/Header header
Relay           relay
```

**Usage:** Publish individual relay commands with timing information.

### RelayCard.msg

Array of relay commands with a common timestamp for synchronized multi-relay control. The variable-length array supports boards with any number of channels.

```
std_msgs/Header header
Relay[]         relays
```

**Usage:** Command multiple relay channels simultaneously with a single synchronized message.

## Design Philosophy

- **Hardware Agnostic**: `node_id` + `channel` addressing decouples commands from physical wiring and hardware-specific indexing schemes
- **Multi-board Support**: `node_id` (stack position) allows a single topic to address multiple relay boards on a shared bus
- **Trip Protection**: `trip_reset` is a first-class field, acknowledging that marine relay systems commonly implement overcurrent/fault latching
- **Proportional Support**: `setpoint` accommodates solid-state and proportional relay types alongside standard binary relays

## Usage

### Publishing a Single Relay Command (Python)

```python
from relay_interfaces.msg import RelayStamped, Relay

msg = RelayStamped()
msg.header.stamp = self.get_clock().now().to_msg()
msg.header.frame_id = 'relay_board'

msg.relay.node_id = 1
msg.relay.channel = 3
msg.relay.powered = True

publisher.publish(msg)
```

### Publishing Multiple Relay Commands (Python)

```python
from relay_interfaces.msg import RelayCard, Relay

msg = RelayCard()
msg.header.stamp = self.get_clock().now().to_msg()
msg.header.frame_id = 'relay_board'

r1 = Relay()
r1.node_id = 1
r1.channel = 0
r1.powered = True

r2 = Relay()
r2.node_id = 1
r2.channel = 1
r2.powered = False
r2.trip_reset = True  # Reset a latched fault on channel 1

msg.relays = [r1, r2]
publisher.publish(msg)
```

## Part of RoShip Interfaces

This package is part of the [RoShip Interfaces](../README.md) collection for marine robotic systems.
