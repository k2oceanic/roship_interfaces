# Hydraulic Interfaces

ROS2 message definitions for hydraulic valve control systems. This package provides standardized interfaces for proportional, reversible, and solenoid valves commonly used in marine robotic platforms.

## Message Types

### Valve.msg
Core message representing a single hydraulic valve state with normalized control values (`-1.0` to `1.0` for reversible, `0.0` to `1.0` for proportional, `0.0` or `1.0` for solenoid valves).

```
int32   valve_id       # Valve identifier (may be indexed from 0, 1, or use hardware-specific IDs)
float64 set_point      # Control value:
                       #   -1.0 to 1.0 for proportional reversible valves
                       #    0.0 to 1.0 for proportional valves
                       #    0.0 or 1.0 for solenoid valves
```

### ValveStamped.msg
Time-stamped single valve command, suitable for control loops requiring precise timing.

```
std_msgs/Header header
Valve           valve
```

**Usage:** Publish individual valve commands with precise timing information.

### ValvePack.msg
Array of valve states with common timestamp for synchronized multi-valve control. The variable-length array supports systems with any number of valves.

```
std_msgs/Header header
Valve[]         valves    # Variable-length array for any number of valves
```

**Usage:** Command multiple valves simultaneously, ensuring synchronized actuation.

## Design Philosophy

- **Hardware Agnostic**: Normalized `set_point` values work across different valve types and manufacturers
- **Flexible Indexing**: `valve_id` field accommodates various indexing schemes (0-based, 1-based, hardware-specific)
- **Synchronization**: Pack messages ensure coordinated actuation with single timestamp

## Usage

### Publishing Valve Commands

```python
from hydraulic_interfaces.msg import ValvePack, Valve

# Create valve pack message
msg = ValvePack()
msg.header.stamp = self.get_clock().now().to_msg()
msg.header.frame_id = 'hydraulic_manifold'

# Command two proportional valves
valve1 = Valve()
valve1.valve_id = 1
valve1.set_point = 0.75  # 75% open

valve2 = Valve()
valve2.valve_id = 2
valve2.set_point = -0.5  # 50% reverse

msg.valves = [valve1, valve2]
publisher.publish(msg)
```

## Part of RoShip Interfaces

This package is part of the [RoShip Interfaces](../README.md) collection for marine robotic systems.
