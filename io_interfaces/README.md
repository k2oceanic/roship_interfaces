# IO Interfaces

ROS2 message definitions for raw input/output device control. This package provides standardized interfaces for analog outputs, digital outputs, relay control, and raw binary sensor data commonly used in marine robotic platforms.

## Message Types

### RawAnalog.msg
Core message representing a single analog output channel with proportional and scaled voltage/current control.

```
int32   channel_id          # Analog channel identifier (may be indexed from 0, 1, or use hardware-specific IDs)

uint8   type                # Output type
uint8   TYPE_VOLTAGE=0
uint8   TYPE_CURRENT=1

float32 scale               # Scale factor: voltage = proportional_value * scale
                            # Set to 0.0 if scale is unknown
float32 proportional_value  # Control value from -1.0 to 1.0
```

### RawAnalogArray.msg
Array of analog channel commands with a common timestamp for devices such as DAC boards. The array may address any subset of channels — only the channels included in the message are affected.

```
std_msgs/Header header
RawAnalog[]     analogs
```

**Usage:** Command one or more analog channels in a single message without needing to address the entire board.

### RawAnalogStamped.msg
Time-stamped single analog channel command published on a per-output per-topic basis.

```
std_msgs/Header header
RawAnalog       analog
```

**Usage:** Command a single analog output without constructing a full array. Useful when multiple independent nodes need to control individual channels on the same device — each node publishes to its own topic without needing awareness of the other channels.

---

### RawDigital.msg
Core message representing a single digital output (DIO) or relay channel.

```
int32   channel_id  # Digital channel identifier (may be indexed from 0, 1, or use hardware-specific IDs)

bool    state       # Commanded output state
                    #   True  = HIGH / energized / closed (relay)
                    #   False = LOW  / de-energized / open (relay)
```

### RawDigitalArray.msg
Array of digital channel commands with a common timestamp for devices such as relay boards or DIO boards. The array may address any subset of channels — only the channels included in the message are affected.

```
std_msgs/Header header
RawDigital[]    digitals
```

**Usage:** Command one or more digital channels in a single message without needing to address the entire board.

### RawDigitalStamped.msg
Time-stamped single digital channel command published on a per-output per-topic basis.

```
std_msgs/Header header
RawDigital      digital
```

**Usage:** Command a single digital output without constructing a full array. Useful when multiple independent nodes need to control individual channels on the same device — each node publishes to its own topic without needing awareness of the other channels.

---

### RawPacket.msg
Raw binary data packet received directly from a sensor or device, published one topic per sensor.

```
std_msgs/Header header  # stamp corresponds to the time the message was generated or decoded
byte[]          data    # Raw binary payload
```

**Usage:** Publish unprocessed binary data from hardware devices. Since each sensor publishes on its own dedicated topic, the source and data format are implicit from the topic name.

---

## Service Types

### ChannelTrigger.srv
Service for triggering a single channel by ID. Returns a success flag and optional message.

```
# Request
int32   channel_id  # Channel identifier to trigger

---

# Response
bool    success     # True if the channel was triggered successfully
string  message     # Human-readable result or error description
```

**Usage:** Send a one-shot trigger command to a specific channel. Suitable for relay pulse operations or any channel-based action that requires acknowledgement.

---

## Design Philosophy

- **Hardware Agnostic**: Normalized values and boolean states work across different device types and manufacturers
- **Flexible Indexing**: `channel_id` fields accommodate various indexing schemes (0-based, 1-based, hardware-specific)
- **Array Messages for Boards**: Array messages address any subset of channels on a multi-output device (relay board, DAC board) in a single timestamped message — only the included channels are affected
- **Stamped Messages for Individual Control**: Stamped messages allow multiple independent nodes to each control a single channel on a shared device without coordinating with other nodes
- **One Topic Per Device**: `RawPacket` is published per sensor per topic, keeping source and format implicit in the topic name rather than the message

## Usage

### Publishing Digital Commands

```python
from io_interfaces.msg import RawDigitalArray, RawDigital

# Create digital array message
msg = RawDigitalArray()
msg.header.stamp = self.get_clock().now().to_msg()
msg.header.frame_id = 'relay_panel'

# Command two relay channels
relay1 = RawDigital()
relay1.channel_id = 1
relay1.state = True   # Energize / close

relay2 = RawDigital()
relay2.channel_id = 2
relay2.state = False  # De-energize / open

msg.digitals = [relay1, relay2]
publisher.publish(msg)
```

### Publishing Analog Commands

```python
from io_interfaces.msg import RawAnalogStamped, RawAnalog

msg = RawAnalogStamped()
msg.header.stamp = self.get_clock().now().to_msg()
msg.header.frame_id = 'analog_output_0'

msg.analog.channel_id = 0
msg.analog.type = RawAnalog.TYPE_VOLTAGE
msg.analog.scale = 10.0          # 10V full scale
msg.analog.proportional_value = 0.5  # 5V output

publisher.publish(msg)
```

## Part of RoShip Interfaces

This package is part of the [RoShip Interfaces](../README.md) collection for marine robotic systems.
