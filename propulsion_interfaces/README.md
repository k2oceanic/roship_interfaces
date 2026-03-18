# Propulsion Interfaces

ROS2 message definitions for thruster and propulsion control systems. This package provides messages that support both proportional control and calibrated thrust commands for underwater and surface vehicles.

## Message Types

### Thrust.msg
Core message representing thruster command with dual representation:
- **Proportional control**: Normalized value from `-1.0` to `1.0`
- **Calibrated thrust**: Optional `scale` factor (N per unit) allows commanded thrust in Newtons
- **Uncalibrated mode**: `scale == 0.0` convention indicates uncalibrated thruster

```
float32 scale               # Thrust scale factor (N per unit proportional_value)
                           # Set to 0.0 if uncalibrated
float32 proportional_value  # Normalized control value from -1.0 to 1.0
```

### ThrustStamped.msg
Time-stamped single thruster command for control loops requiring precise timing and coordination.

```
std_msgs/Header header
Thrust          thrust
```

**Usage:** Command individual thrusters with timing information for control loops.

### ThrustArray.msg
Array of thruster commands with common timestamp for complete propulsion system control. Variable-length array supports any thruster configuration.

```
std_msgs/Header header
Thrust[]        thrusts
```

**Usage:** Command complete thruster configuration in a single message, ensuring coordinated propulsion control.

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

# Command calibrated thrusters
thrust1 = Thrust()
thrust1.scale = 50.0  # 50 N per unit
thrust1.proportional_value = 0.8  # 40 N forward

thrust2 = Thrust()
thrust2.scale = 50.0
thrust2.proportional_value = -0.6  # 30 N reverse

msg.thrusts = [thrust1, thrust2]
publisher.publish(msg)
```

## Part of RoShip Interfaces

This package is part of the [RoShip Interfaces](../README.md) collection for marine robotic systems.
