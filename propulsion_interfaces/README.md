# Propulsion Interfaces

ROS2 message definitions for thruster and propulsion control systems. This package provides standardized interfaces for proportional and calibrated thrust commands for underwater and surface vehicles.

## Message Types

### Thrust.msg
Core message representing a single thruster command with proportional and optional calibrated thrust values.

```
int32   thruster_id         # Thruster identifier (may be indexed from 0, 1, or use hardware-specific IDs)

float32 scale               # Scale factor: thrust_N = proportional_value * scale
                            # Set to 0.0 if uncalibrated
float32 proportional_value  # Control value from -1.0 to 1.0
```

### ThrustArray.msg
Array of thruster commands with a common timestamp for devices such as thruster controllers. The array may address any subset of thrusters — only the thrusters included in the message are affected.

```
std_msgs/Header header
Thrust[]        thrusts
```

**Usage:** Command one or more thrusters in a single message without needing to address the entire propulsion system. Well suited for speed controllers or motor controllers with multiple outputs, where all channels are driven from a single device or control loop.

### ThrustStamped.msg
Time-stamped single thruster command published on a per-thruster per-topic basis.

```
std_msgs/Header header
Thrust          thrust
```

**Usage:** Command a single thruster without constructing a full array. Useful when multiple independent nodes need to control individual thrusters — each node publishes to its own topic without needing awareness of the other thrusters.

## Design Philosophy

- **Calibration Flexibility**: Supports both calibrated (Newtons) and uncalibrated (proportional) operation
- **Safe Defaults**: `scale == 0.0` produces valid zero thrust, allowing runtime detection of uncalibrated systems
- **Unified Control**: Single message type for forward/reverse thrust with signed proportional values

## Thrust Calculation

Actual thrust in Newtons is computed as:
```
thrust_N = proportional_value × scale
```

When `scale == 0.0`, the system operates in proportional-only mode.

## Usage

### Publishing Thrust Commands

```python
from propulsion_interfaces.msg import ThrustArray, Thrust

# Create thrust array message
msg = ThrustArray()
msg.header.stamp = self.get_clock().now().to_msg()
msg.header.frame_id = 'base_link'

# Command two calibrated thrusters
thrust1 = Thrust()
thrust1.thruster_id = 1
thrust1.scale = 50.0             # 50 N full scale
thrust1.proportional_value = 0.8 # 40 N forward

thrust2 = Thrust()
thrust2.thruster_id = 2
thrust2.scale = 50.0
thrust2.proportional_value = -0.6 # 30 N reverse

msg.thrusts = [thrust1, thrust2]
publisher.publish(msg)
```

## Part of RoShip Interfaces

This package is part of the [RoShip Interfaces](../README.md) collection for marine robotic systems.