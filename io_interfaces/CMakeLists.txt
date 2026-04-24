cmake_minimum_required(VERSION 3.8)

project(io_interfaces)

find_package(ament_cmake REQUIRED)
find_package(rosidl_default_generators REQUIRED)
find_package(std_msgs REQUIRED)

set(MSG_FILES
    "msg/RawPacket.msg"
    "msg/RawAnalog.msg"
    "msg/RawAnalogArray.msg"
    "msg/RawAnalogStamped.msg"
    "msg/RawDigital.msg"
    "msg/RawDigitalArray.msg"
    "msg/RawDigitalStamped.msg")

set(SRV_FILES
    "srv/ChannelTrigger.srv")

rosidl_generate_interfaces(${PROJECT_NAME}
    ${MSG_FILES}
    ${SRV_FILES}
    DEPENDENCIES
    std_msgs)

ament_export_dependencies(rosidl_default_runtime)

ament_package()
