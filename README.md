# RoShip Interfaces

ROS2 interface definitions for marine robotic systems. This package provides standardized message types for hydraulic control and propulsion systems commonly found on ROVs (Remotely Operated Vehicles) and other underwater and autonomous ocean platforms.

## Overview

RoShip (Robotic Ship) is a collection of standards and supporting software packages for operating robotic systems in marine environments. This interface package contains message definitions organized into domain-specific sub-packages:

- **[hydraulic_interfaces](hydraulic_interfaces/README.md)** - Messages for hydraulic valve control systems
- **[propulsion_interfaces](propulsion_interfaces/README.md)** - Messages for thruster and propulsion systems

## Design Philosophy

These messages follow ROS2 best practices and conventions:

- **Generality**: Messages support a wide variety of hardware implementations
- **Flexibility**: Variable-length arrays allow representation of systems with any number of actuators
- **Standards Compliance**: Follows [ROS2 Message Conventions](https://docs.ros.org/en/rolling/Concepts/About-ROS-Interfaces.html)
- **Simplicity**: Core messages are intentionally minimal; hardware-specific metadata should be published separately

## Installation

### From Source

```bash
cd ~/ros2_ws/src
git clone https://github.com/k2oceanic/roship_interfaces.git
cd ~/ros2_ws
colcon build --packages-select roship_interfaces
source install/setup.bash
```

## Package Structure

```
roship_interfaces/
├── hydraulic_interfaces/
│   ├── msg/
│   │   ├── Valve.msg
│   │   ├── ValveStamped.msg
│   │   └── ValvePack.msg
│   ├── CMakeLists.txt
│   └── package.xml
├── propulsion_interfaces/
│   ├── msg/
│   │   ├── Thrust.msg
│   │   ├── ThrustStamped.msg
│   │   └── ThrustArray.msg
│   ├── CMakeLists.txt
│   └── package.xml
├── LICENSE
└── README.md
```

## Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

When proposing new messages or modifications:
1. Ensure compatibility with existing ROS2 conventions
2. Maintain hardware-agnostic design where possible
3. Document design decisions and use cases
4. Update this README with message documentation

## License

This package is licensed under the Apache 2.0 License. See [LICENSE](LICENSE) for details.

## Maintainer

- **Kristopher Krasnosky** - support@seaward.science

## Version

**1.0.0** - Initial stable release

## Credits

Developed by [Seaward Science](https://seaward.science/).

### Authors
- Dr. Kristopher Krasnosky (lead software engineer)
- Jake Bonney

### Citation