# Changelog

All notable changes to the **Resources** project will be documented in this file.

## [0.0.5] - 2026-03-02

### Added

- Created `PageHeader` and `DashboardCard` reusable components.
- Added `README.md` and `CHANGELOG.md`.

### Changed

- Global UI/UX Redesign: Unified look across all monitoring pages.
- Sidebar Navigation: Replaced old indicators with rounded modern pill-style buttons.
- Improved sensor labels and filtering (hiding ghost/invalid motherboard readings).

### Fixed

- Fixed QML Column anchor warnings in CPU and Memory pages.
- Fixed NaN display for total memory on Memory page.
- Fixed clipping issues where graphs would bleed outside of rounded card corners.

## [0.0.1] - Initial Scaffolding

- Basic system monitor shell with CPU, RAM, and Disk overview.
- Linux backend for reading /proc files.
