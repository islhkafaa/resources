# Resources

A high-performance, modern system monitor built with C++20 and Qt 6.

[![Latest Version](https://img.shields.io/badge/version-0.0.5-blue.svg)](CHANGELOG.md)
[![Changelog](https://img.shields.io/badge/changelog-view-orange.svg)](CHANGELOG.md)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

![Preview](preview.png)

## Features

- **CPU Monitoring**: Real-time per-core usage and model information.
- **Memory & Swap**: Detailed memory breakdown with historical usage graphs.
- **Disk I/O**: Read/Write throughput monitoring per device.
- **Network Stats**: Receive/Transmit speed monitoring per interface (Mbps).
- **Sensors**: Clean thermal reporting from `hwmon` and `thermal_zone`.
- **Modern UI**: Dark mode, glassmorphism-inspired design with Inter typography.

## Requirements

- Linux (Support for `/proc` and `/sys` interfaces)
- Qt 6.x (Core, Quick, Svg, QuickControls2)
- C++20 compatible compiler (Clang/GCC)
- CMake 3.16+

## Building

```bash
mkdir build && cd build
cmake ..
make
./resources
```
