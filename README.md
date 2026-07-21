<div align="center">
  <!-- <img src="docs/images/lumisense_logo.png" alt="LumiSense Logo" width="200"/> -->
  <h1>LumiSense</h1>
  <h3>Smart Light Automation System</h3>
  <p>
    <strong>Flutter + ESP32-C3 + MQTT</strong>
  </p>
  
  [![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)](https://flutter.dev)
  [![ESP32](https://img.shields.io/badge/ESP32-C3-red.svg)](https://www.espressif.com)
  [![Arduino](https://img.shields.io/badge/Arduino-IDE-green.svg)](https://www.arduino.cc)
  [![MQTT](https://img.shields.io/badge/MQTT-5.0-orange.svg)](https://mqtt.org)
  [![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
  [![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)
</div>

---

## 📋 Table of Contents

- [Overview](#-overview)
- [Features](#-features)
- [Hardware Requirements](#-hardware-requirements)
- [Architecture](#-architecture)
- [Circuit Diagram](#-circuit-diagram)
- [Project Structure](#-project-structure)
- [Flutter App Setup](#-flutter-app-setup)
- [ESP32 Firmware Setup](#-esp32-firmware-setup)
- [MQTT Configuration](#-mqtt-configuration)
- [Screenshots](#-screenshots)
- [Troubleshooting](#-troubleshooting)
- [Future Improvements](#-future-improvements)
- [Contributing](#-contributing)
- [License](#-license)

---

## 🎯 Overview

**LumiSense** is a professional smart light automation system built with **Flutter** and **ESP32-C3**, demonstrating modern IoT integration, real-time communication, and clean architecture practices. The system uses an LM393 LDR sensor to detect ambient light levels and automatically adjusts LED brightness for optimal lighting conditions.

This project showcases:
- **Cross-platform mobile development** with Flutter
- **Embedded systems programming** with ESP32-C3
- **Real-time communication** using MQTT protocol
- **Clean architecture** with Riverpod state management
- **Professional development practices** including MVVM, Repository Pattern, and Service Layer

### 🎯 Target Audience
- **Flutter Developers** looking to integrate IoT
- **Embedded Systems Engineers** building smart devices
- **IoT Solutions Architects** designing connected systems
- **Students & Recruiters** evaluating portfolio projects

---

## ✨ Features

### 📱 Flutter App

#### Dashboard
- **Real-time LDR Monitoring** - Live ambient light readings with visual indicators
- **Device Status** - Online/offline status with uptime tracking
- **MQTT Status** - Connection status to broker
- **LED Control** - Toggle LEDs ON/OFF with one tap
- **Mode Switching** - Toggle between Auto and Manual modes
- **Brightness Control** - Slider-based brightness adjustment (0-255)
- **Threshold Control** - Adjust LDR sensitivity for auto mode

#### History & Analytics
- **Interactive Charts** - Visualize LDR history with fl_chart
- **Statistics Dashboard** - Average, Max, Min LDR values
- **Brightness Analytics** - Track brightness patterns over time
- **Chronological List** - View historical data with timestamps
- **CSV Export** - Export telemetry data for external analysis

#### Settings
- **Mode Preferences** - Default auto/manual mode
- **Notification Controls** - Enable/disable local notifications
- **Data Management** - Clear history with confirmation
- **App Information** - Version, license, and about section

#### Notifications
- Dark room detected
- Bright room detected
- Mode changed
- Connection lost
- Connection restored

### 🔌 ESP32 Firmware

#### Core Features
- **LDR Sensor Reading** - Reads LM393 sensor with moving average filtering
- **PWM LED Control** - 8-bit PWM for smooth brightness control
- **Auto Mode** - Automatically adjusts brightness based on ambient light
- **Manual Mode** - Full manual control over LED brightness
- **Threshold Logic** - Configurable LDR threshold for auto mode

#### Communication
- **MQTT Publish** - Telemetry, status, brightness, and mode
- **MQTT Subscribe** - Commands for mode, brightness, threshold, and LED
- **Retained Messages** - State persistence across reboots
- **Offline Detection** - Automatic reconnection with status reporting

#### Individual LED Control
- **6 Colors** - Red, Green, Yellow, White, Blue, Orange
- **Independent Control** - Each LED can be controlled separately
- **PWM Dimming** - Smooth brightness control per LED
- **Status Reporting** - JSON status for each LED

---

## 🛠️ Hardware Requirements

### Components List

| Component | Quantity | Description | Where to Buy |
|-----------|----------|-------------|--------------|
| Seeed Studio XIAO ESP32-C3 | 1 | Microcontroller board | [Seeed Studio](https://www.seeedstudio.com/) |
| LM393 LDR Sensor Module | 1 | Ambient light sensor | [Amazon](https://www.amazon.com) |
| LEDs (Various Colors) | 6 | Red, Green, Yellow, White, Blue, Orange | [Amazon](https://www.amazon.com) |
| 220Ω Resistors | 6 | Current limiting for LEDs | [Amazon](https://www.amazon.com) |
| Breadboard | 1 | Prototyping board | [Amazon](https://www.amazon.com) |
| Jumper Wires | 15+ | Male-to-female/male-to-male | [Amazon](https://www.amazon.com) |
| USB-C Cable | 1 | Programming and power | [Amazon](https://www.amazon.com) |

### Estimated Cost
- **Budget**: $30-50 USD
- **Time**: 2-3 hours for assembly

---

## 🏗️ Architecture

### Flutter Architecture (MVVM + Riverpod)
```
┌──────────────────────────────────────────────────────────────────────┐
│                          PRESENTATION LAYER                          │
│    ┌──────────────────┐ ┌──────────────────┐ ┌──────────────────┐    │
│    │     Dashboard    │ │      History     │ │      Settings    │    │
│    │       Page       │ │       Page       │ │       Page       │    │
│    └────────┬─────────┘ └────────┬─────────┘ └────────┬─────────┘    │
│             │                    │                    │              │
│    ┌────────▼─────────┐ ┌────────▼─────────┐ ┌────────▼─────────┐    │
│    │      Widgets     │ │      Widgets     │ │      Widgets     │    │
│    │    (Reusable)    │ │    (Reusable)    │ │    (Reusable)    │    │
│    └────────┬─────────┘ └────────┬─────────┘ └────────┬─────────┘    │
│             │                    │                    │              │
│    ┌────────▼────────────────────▼────────────────────▼─────────┐    │
│    │           Riverpod Providers / State Management            │    │
│    └────────────────────────────┬───────────────────────────────┘    │
└─────────────────────────────────┼────────────────────────────────────┘
                                  │
┌─────────────────────────────────▼────────────────────────────────────┐
│                           DOMAIN LAYER                               │
│    ┌──────────────────┐ ┌──────────────────┐ ┌──────────────────┐    │
│    │  Device Service  │ │   MQTT Service   │ │ History Service  │    │
│    └────────┬─────────┘ └────────┬─────────┘ └────────┬─────────┘    │
│             │                    │                    │              │
│    ┌────────▼────────────────────▼────────────────────▼─────────┐    │
│    │                  Domain Models / Entities                  │    │
│    └────────────────────────────────────────────────────────────┘    │
└──────────────────────────────────────────────────────────────────────┘
                                   │
┌──────────────────────────────────▼───────────────────────────────────┐
│                              DATA LAYER                              │
│    ┌──────────────────┐ ┌──────────────────┐ ┌──────────────────┐    │
│    │  MQTT Repository │ │   History Repo   │ │   Settings Repo  │    │
│    └────────┬─────────┘ └────────┬─────────┘ └────────┬─────────┘    │
│             │                    │                    │              │
│    ┌────────▼────────────────────▼────────────────────▼─────────┐    │
│    │           Data Sources (MQTT, SharedPreferences)           │    │
│    └────────────────────────────────────────────────────────────┘    │
└──────────────────────────────────────────────────────────────────────┘
                                   │
┌──────────────────────────────────▼───────────────────────────────────┐
│                             INFRASTRUCTURE                           │
│    ┌──────────────────┐ ┌──────────────────┐ ┌──────────────────┐    │
│    │    MQTT Broker   │ │   Local Storage  │ │   Notifications  │    │
│    └──────────────────┘ └──────────────────┘ └──────────────────┘    │
└──────────────────────────────────────────────────────────────────────┘

```


### ESP32 Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│                                ESP32-C3                             │
│ ┌─────────────────────────────────────────────────────────────────┐ │
│ │                              MAIN LOOP                          │ │
│ └───────────────────────────────┬─────────────────────────────────┘ │
│                                 │                                   │
│ ┌───────────────────────────────▼─────────────────────────────────┐ │
│ │                               MANAGERS                          │ │
│ │       ┌──────────────┐ ┌──────────────┐ ┌──────────────┐        │ │
│ │       │     WiFi     │ │     MQTT     │ │    Sensor    │        │ │
│ │       │    Manager   │ │    Manager   │ │   Manager    │        │ │
│ │       └──────────────┘ └──────────────┘ └──────────────┘        │ │
│ │               ┌──────────────┐ ┌──────────────┐                 │ │
│ │               │     LED      │ │     Data     │                 │ │
│ │               │   Manager    │ │    Manager   │                 │ │
│ │               └──────────────┘ └──────────────┘                 │ │
│ └───────────────────────────────┬─────────────────────────────────┘ │
│                                 │                                   │
│ ┌───────────────────────────────▼─────────────────────────────────┐ │
│ │                            HARDWARE                             │ │
│ │       ┌──────────────┐ ┌──────────────┐ ┌──────────────┐        │ │
│ │       │   LM393 LDR  │ │    6x LEDs   │ │      PWM     │        │ │
│ │       │    Sensor    │ │   (Colors)   │ │    Control   │        │ │
│ │       └──────────────┘ └──────────────┘ └──────────────┘        │ │
│ └─────────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────────┘
                                  │
┌─────────────────────────────────▼───────────────────────────────────┐
│                           COMMUNICATION                             │
│ ┌─────────────────────────────────────────────────────────────────┐ │
│ │                          MQTT Broker                            │ │
│ │                      (HiveMQ / Mosquitto)                       │ │
│ └─────────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────────┘

```


### MQTT Communication Flow

```
┌─────────────────────────────────────────────────────────────────────┐
│                              FLUTTER APP                            │
│                            (Mobile Device)                          │
│ ┌─────────────────────────────────────────────────────────────────┐ │
│ │                          PUBLISH COMMANDS                       │ │
│ │ • mode (auto/manual)                                            │ │
│ │ • brightness (0-255)                                            │ │
│ │ • threshold (0-1023)                                            │ │
│ │ • led (on/off)                                                  │ │
│ │ • led_color (color,brightness)                                  │ │
│ └─────────────────────────────────────────────────────────────────┘ │
└──────────────────────────────────┬──────────────────────────────────┘
                                   │
                                   │ MQTT Protocol (TCP/IP)
                                   │ Port: 1883
                                   │
┌──────────────────────────────────▼──────────────────────────────────┐
│                             MQTT BROKER                             │
│                      (HiveMQ Public / Mosquitto)                    │
│ ┌─────────────────────────────────────────────────────────────────┐ │
│ │                     Message Routing & Delivery                  │ │
│ │ • QoS 0, 1, 2 Support                                           │ │
│ │ • Retained Messages                                             │ │
│ │ • Last Will and Testament                                       │ │
│ └─────────────────────────────────────────────────────────────────┘ │
└──────────────────────────────────┬──────────────────────────────────┘
                                   │
                                   │ MQTT Protocol (TCP/IP)
                                   │ Port: 1883
                                   │
┌──────────────────────────────────▼──────────────────────────────────┐
│                               ESP32-C3                              │
│                               (Device)                              │
│ ┌─────────────────────────────────────────────────────────────────┐ │
│ │                       SUBSCRIBE TO TOPICS                       │ │
│ │ • lumisense/esp32_001/command/#                                 │ │
│ └─────────────────────────────────────────────────────────────────┘ │
│ ┌─────────────────────────────────────────────────────────────────┐ │
│ │                        PUBLISH TELEMETRY                        │ │
│ │ • ldr value (0-1023)                                            │ │
│ │ • device status (JSON)                                          │ │
│ │ • mode (auto/manual)                                            │ │
│ │ • brightness (0-255)                                            │ │
│ │ • led_status (JSON)                                             │ │
│ └─────────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────────┘

```

---

## 🔌 Circuit Diagram

### Pin Connections for XIAO ESP32-C3

```
┌─────────────────────────────────────────────────────────────────────┐
│                         XIAO ESP32-C3 Pinout                        │
│                                                                     │
│   ┌─────────────────────────────────────────────────────────────┐   │
│   │                                                             │   │
│   │                            ┌───┐                            │   │
│   │                            │USB│                            │   │
│   │                            └───┘                            │   │
│   │                                                             │   │
│   │       D0 ──────────────────┬────[220Ω]───── Red LED         │   │
│   │       D1 ──────────────────┼────[220Ω]───── Green LED       │   │
│   │       D2 ──────────────────┼────[220Ω]───── Yellow LED      │   │
│   │       D5 ──────────────────┼────[220Ω]───── White LED       │   │
│   │       D6 ──────────────────┼────[220Ω]───── Blue LED        │   │
│   │       D7 ──────────────────┼────[220Ω]───── Orange LED      │   │
│   │       D8 ──────────────────► LM393 LDR Sensor (DO)          │   │
│   │                                                             │   │
│   │       3.3V ─────────────────► VCC (LDR & LEDs)              │   │
│   │       GND ──────────────────► GND (LDR & LEDs)              │   │
│   └─────────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────┘

Legend:
─────► Wire Connection
[220Ω] Resistor
LED Light Emitting Diode

```

### Detailed Wiring Table

| ESP32-C3 Pin |    Component    |    Signal    |    Color    |         Function         |
|--------------|-----------------|--------------|-------------|--------------------------|
| D0 (GPIO2)   |     Red LED     |     PWM      |     Red     |  Individual LED Control  |
| D1 (GPIO3)   |    Green LED    |     PWM      |    Green    |  Individual LED Control  |
| D2 (GPIO4)   |    Yellow LED   |     PWM      |    Yellow   |  Individual LED Control  |
| D5 (GPIO5)   |    White LED    |     PWM      |    White    |  Individual LED Control  |
| D6 (GPIO6)   |     Blue LED    |     PWM      |    Blue     |  Individual LED Control  |
| D7 (GPIO7)   |    Orange LED   |     PWM      |   Orange    |  Individual LED Control  |
| D8 (GPIO8)   |    LM393 LDR    |    Analog    |     -       |  Ambient Light Sensing   |
| 3.3V         |      Power      |      VCC     |     Red     |       Power Supply       |
| GND          |      Ground     |      GND     |    Black    |      Common Ground       |

### Breadboard Layout

```
┌─────────────────────────────────────────────────────────────────────┐
│                             BREADBOARD                              │
│ ┌─────────────────────────────────────────────────────────────────┐ │
│ │                          POWER RAILS                            │ │
│ │ (+) 3.3V ────────────────────────────────────────────────────   │ │
│ │ (-) GND ────────────────────────────────────────────────────    │ │
│ └─────────────────────────────────────────────────────────────────┘ │
│                                                                     │
│ ┌─────────────────────────────────────────────────────────────────┐ │
│ │                        LED CONNECTIONS                          │ │
│ │                                                                 │ │
│ │ D0 ───[220Ω]───▶|▷|─── GND Red                                 │ │
│ │ D1 ───[220Ω]───▶|▷|─── GND Green                               │ │
│ │ D2 ───[220Ω]───▶|▷|─── GND Yellow                              │ │
│ │ D5 ───[220Ω]───▶|▷|─── GND White                               │ │
│ │ D6 ───[220Ω]───▶|▷|─── GND Blue                                │ │
│ │ D7 ───[220Ω]───▶|▷|─── GND Orange                              │ │
│ └─────────────────────────────────────────────────────────────────┘ │  
│                                                                     │
│ ┌─────────────────────────────────────────────────────────────────┐ │
│ │                         LDR CONNECTION                          │ │
│ │                                                                 │ │
│ │ 3.3V ─────────── VCC                                            │ │
│ │ GND ─────────── GND                                             │ │
│ │ D8 ─────────── DO (Analog Output)                               │ │
│ └─────────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────────┘

```

### Step-by-Step Wiring Instructions

1. **Power Rails**:
   - Connect 3.3V to the positive rail
   - Connect GND to the negative rail

2. **LEDs**:
   - Place 6 LEDs on the breadboard (one per color)
   - Connect each LED's anode (long leg) through a 220Ω resistor to the designated pin
   - Connect all LED cathodes (short leg) to GND rail

3. **LDR Sensor**:
   - Place LM393 module on breadboard
   - Connect VCC to 3.3V rail
   - Connect GND to GND rail
   - Connect DO to D8 (Analog input)

4. **ESP32-C3**:
   - Insert XIAO ESP32-C3 into breadboard
   - Connect power and ground
   - Connect all signal pins according to the table

5. **Double Check**:
   - Verify all connections
   - Ensure correct polarity (LEDs are polarized)
   - Check resistor values (220Ω)

---

## 📁 Project Structure

```

LumiSense/
│
├── flutter_app/ # Flutter Mobile Application
│ ├── android/ # Android build files
│ ├── ios/ # iOS build files
│ ├── lib/ # Application source code
│ │ ├── main.dart # Application entry point
│ │ ├── app/ # App-level configuration
│ │ │ ├── app.dart # Main app widget
│ │ │ └── routes.dart # Navigation routes
│ │ ├── core/ # Core utilities and constants
│ │ │ ├── constants/ # Application constants
│ │ │ │ ├── app_constants.dart # App-wide constants
│ │ │ │ └── mqtt_topics.dart # MQTT topic definitions
│ │ │ ├── theme/ # Theme configuration
│ │ │ │ ├── app_theme.dart # Light theme
│ │ │ │ └── dark_theme.dart # Dark theme
│ │ │ ├── utils/ # Utility functions
│ │ │ │ ├── date_formatter.dart # Date formatting
│ │ │ │ └── permission_handler.dart # Permission management
│ │ │ └── widgets/ # Core reusable widgets
│ │ │ ├── loading_widget.dart # Loading indicator
│ │ │ ├── error_widget.dart # Error display
│ │ │ └── empty_state_widget.dart # Empty state display
│ │ ├── features/ # Feature modules
│ │ │ ├── dashboard/ # Dashboard feature
│ │ │ │ ├── domain/ # Domain models
│ │ │ │ │ ├── models/ # Data models
│ │ │ │ │ │ ├── device_status.dart
│ │ │ │ │ │ └── light_data.dart
│ │ │ │ │ └── services/ # Domain services
│ │ │ │ │ └── device_service.dart
│ │ │ │ └── presentation/ # UI layer
│ │ │ │ ├── pages/ # Pages
│ │ │ │ │ └── dashboard_page.dart
│ │ │ │ ├── providers/ # State providers
│ │ │ │ │ └── dashboard_providers.dart
│ │ │ │ └── widgets/ # Page widgets
│ │ │ │ ├── device_status_card.dart
│ │ │ │ ├── mqtt_status_card.dart
│ │ │ │ ├── light_control_card.dart
│ │ │ │ ├── brightness_control_card.dart
│ │ │ │ ├── threshold_control_card.dart
│ │ │ │ ├── ldr_value_card.dart
│ │ │ │ └── mode_control_card.dart
│ │ │ ├── history/ # History feature
│ │ │ │ ├── data/ # Data layer
│ │ │ │ │ ├── datasources/ # Data sources
│ │ │ │ │ │ ├── local_history_datasource.dart
│ │ │ │ │ │ └── shared_preferences_datasource.dart
│ │ │ │ │ └── repositories/ # Repositories
│ │ │ │ │ └── history_repository.dart
│ │ │ │ ├── domain/ # Domain layer
│ │ │ │ │ ├── models/ # Data models
│ │ │ │ │ │ └── history_record.dart
│ │ │ │ │ └── services/ # Domain services
│ │ │ │ │ ├── history_service.dart
│ │ │ │ │ └── export_service.dart
│ │ │ │ └── presentation/ # UI layer
│ │ │ │ ├── pages/ # Pages
│ │ │ │ │ └── history_page.dart
│ │ │ │ ├── providers/ # State providers
│ │ │ │ │ └── history_providers.dart
│ │ │ │ └── widgets/ # Page widgets
│ │ │ │ ├── history_chart.dart
│ │ │ │ ├── history_list.dart
│ │ │ │ └── statistics_widget.dart
│ │ │ ├── mqtt/ # MQTT feature
│ │ │ │ ├── data/ # Data layer
│ │ │ │ │ ├── datasources/ # Data sources
│ │ │ │ │ │ └── mqtt_datasource.dart
│ │ │ │ │ └── repositories/ # Repositories
│ │ │ │ │ └── mqtt_repository.dart
│ │ │ │ ├── domain/ # Domain layer
│ │ │ │ │ ├── models/ # Data models
│ │ │ │ │ │ └── mqtt_message.dart
│ │ │ │ │ └── services/ # Domain services
│ │ │ │ │ ├── mqtt_service.dart
│ │ │ │ │ └── mqtt_connection_service.dart
│ │ │ │ └── presentation/ # UI layer
│ │ │ │ └── providers/ # State providers
│ │ │ │ └── mqtt_providers.dart
│ │ │ ├── settings/ # Settings feature
│ │ │ │ ├── data/ # Data layer
│ │ │ │ │ └── repositories/ # Repositories
│ │ │ │ │ └── settings_repository.dart
│ │ │ │ ├── domain/ # Domain layer
│ │ │ │ │ ├── models/ # Data models
│ │ │ │ │ │ └── app_settings.dart
│ │ │ │ │ └── services/ # Domain services
│ │ │ │ │ └── settings_service.dart
│ │ │ │ └── presentation/ # UI layer
│ │ │ │ ├── pages/ # Pages
│ │ │ │ │ └── settings_page.dart
│ │ │ │ └── providers/ # State providers
│ │ │ │ └── settings_providers.dart
│ │ │ └── notifications/ # Notifications feature
│ │ │ ├── data/ # Data layer
│ │ │ │ └── datasources/ # Data sources
│ │ │ │ └── local_notification_datasource.dart
│ │ │ └── domain/ # Domain layer
│ │ │ └── services/ # Domain services
│ │ │ └── notification_service.dart
│ │ ├── shared/ # Shared components
│ │ │ └── widgets/ # Shared widgets
│ │ │ ├── app_bar.dart # Custom app bar
│ │ │ ├── bottom_navigation.dart # Bottom navigation
│ │ │ ├── gradient_button.dart # Gradient button
│ │ │ └── custom_slider.dart # Custom slider
│ │ └── config/ # Configuration
│ │ └── riverpod.dart # Riverpod configuration
│ ├── pubspec.yaml # Flutter dependencies
│ ├── pubspec.lock # Locked dependencies
│ └── assets/ # Assets
│ ├── images/ # Images
│ └── fonts/ # Custom fonts
│
├── esp32_firmware_arduino/ # ESP32 Firmware (Arduino IDE)
│ └── LumiSense_ESP32/ # Main sketch folder
│ ├── LumiSense_ESP32.ino # Main Arduino sketch
│ ├── config.h # Configuration file
│ ├── wifi_manager.h # WiFi manager header
│ ├── wifi_manager.cpp # WiFi manager implementation
│ ├── mqtt_manager.h # MQTT manager header
│ ├── mqtt_manager.cpp # MQTT manager implementation
│ ├── sensor_manager.h # Sensor manager header
│ ├── sensor_manager.cpp # Sensor manager implementation
│ ├── led_manager.h # LED manager header
│ ├── led_manager.cpp # LED manager implementation
│ ├── data_manager.h # Data manager header
│ └── data_manager.cpp # Data manager implementation
│
├── docs/ # Documentation
│ ├── architecture/ # Architecture diagrams
│ │ ├── flutter_architecture.mermaid
│ │ ├── esp32_architecture.mermaid
│ │ └── mqtt_flow.mermaid
│ ├── images/ # Documentation images
│ ├── setup/ # Setup guides
│ │ ├── flutter_setup.md
│ │ └── esp32_setup.md
│ └── wiring/ # Wiring documentation
│ └── wiring_diagram.md
│
├── .github/ # GitHub configuration
│ └── workflows/ # GitHub Actions
│ └── flutter_ci.yml # CI/CD pipeline
│
├── .gitignore # Git ignore file
├── LICENSE # MIT License
├── CHANGELOG.md # Version changelog
└── README.md # Project documentation (this file)

```

---

## 📱 Flutter App Setup

### Prerequisites

- **Flutter SDK**: 3.0.0 or higher
- **Dart SDK**: 3.0.0 or higher
- **Android Studio** / **VS Code** with Flutter extensions
- **Android Emulator** or **Physical Device** (Android 5.0+ / iOS 12+)
- **Git** (for version control)

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/yourusername/lumisense.git
cd lumisense/flutter_app

# 2. Install dependencies
flutter pub get

# 3. Generate Riverpod code
flutter pub run build_runner build --delete-conflicting-outputs

# 4. Run the application
flutter run

# For release build
flutter build apk --release
flutter build ios --release
```

### Configuration

1. MQTT Broker: Update lib/core/constants/app_constants.dart

```bash
static const String mqttBroker = 'broker.hivemq.com';  // Or your broker
static const int mqttPort = 1883;
```
2. MQTT Topics: Update lib/core/constants/mqtt_topics.dart

```bash
static const String baseTopic = 'lumisense';
static const String deviceId = 'esp32_001';
```
3. Default Values: Adjust in app_constants.dart

```bash
static const int defaultThreshold = 500;
static const int defaultBrightness = 128;
static const bool defaultAutoMode = true;
```

### Troubleshooting

#### Build Errors
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter run
```
### MQTT Connection Issues

1. Check internet connectivity
2. Verify broker address and port
3. Check firewall settings
4. Try alternative brokers:
  - test.mosquitto.org
  - broker.emqx.io
  - 52.48.82.151 (HiveMQ IP)

### Permission Issues
```bash
# Android
# Ensure INTERNET permission in AndroidManifest.xml

# iOS
# Add appropriate permissions in Info.plist
```
---

## 🔌 ESP32 Firmware Setup

### Prerequisites
- Arduino IDE: 2.0.0 or higher
- ESP32 Board Package: 2.0.0 or higher
- Libraries:

  -  PubSubClient (for MQTT)
  -  WiFi (built-in)

### Arduino IDE Setup
1. Install Arduino IDE
 - Download from arduino.cc

2. Install ESP32 Board Support
  
  - Open Arduino IDE
  - Go to File > Preferences
  - Add to Additional Boards Manager URLs:
  ```bash
(https://raw.githubusercontent.com/espressif/arduino-esp32/gh-pages/package_esp32_index.json)
```
  - Go to Tools > Board > Boards Manager
  - Search for esp32
  - Install esp32 by Espressif Systems

3. Install Required Libraries
  - Go to Sketch > Include Library > Manage Libraries
  - Install PubSubClient by Nick O'Leary

### Firmware Configuration
1. Open Sketch: Open esp32_firmware_arduino/LumiSense_ESP32/LumiSense_ESP32.ino

2. Update WiFi Credentials: In config.h
```bash
#define WIFI_SSID "YourWiFiSSID"
#define WIFI_PASSWORD "YourWiFiPassword"
```
3. Update MQTT Settings: In config.h
```bash
#define MQTT_BROKER "broker.hivemq.com"  // Your broker
#define MQTT_PORT 1883
#define MQTT_CLIENT_ID "esp32_lumisense_001"
```
4. Verify Pin Assignments: In config.h
```bash
#define LED_PIN_RED D0
#define LED_PIN_GREEN D1
#define LED_PIN_YELLOW D2
#define LED_PIN_WHITE D5
#define LED_PIN_BLUE D6
#define LED_PIN_ORANGE D7
#define LDR_PIN D8
```
### Uploading Firmware
1. Select Board:
 - Tools > Board > ESP32 Arduino
 - Select XIAO_ESP32C3 or ESP32C3 Dev Module
2. Select Port:
 - Tools > Port
 - Select your ESP32-C3's COM port
3. Upload:
 - Click Upload button (→)
 - Wait for completion
4. Open Serial Monitor:
 - Tools > Serial Monitor
 - Baud rate: 115200
 - Verify output shows successful connections

### Expected Serial Output
```bash
╔═══════════════════════════════════════╗
║      LumiSense ESP32-C3 v1.0.0      ║
║    Smart Light Automation System     ║
║    6x LED Colors + LDR Sensor       ║
╚═══════════════════════════════════════╝
Initializing hardware...
Connecting to WiFi ......
✓ WiFi connected!
  IP Address: 192.168.1.xxx
Connecting to MQTT broker... ✓ Connected!
📡 Subscribed to: lumisense/esp32_001/command/mode
📡 Subscribed to: lumisense/esp32_001/command/brightness
📡 Subscribed to: lumisense/esp32_001/command/threshold
📡 Subscribed to: lumisense/esp32_001/command/led
📡 Subscribed to: lumisense/esp32_001/command/led_color
✓ Setup complete!
=========================================
🔦 LDR Raw: 512 | Filtered: 510
📤 Published LDR: 510
📤 Published Brightness: 128
📡 Status updated: {"online":true,"uptime":"00:00:05",...}
```
### Troubleshooting
#### Compilation Errors
1. Board not found: Install ESP32 board package
2. Library missing: Install PubSubClient library
3. Pin errors: Verify pin definitions in config.h
#### Connection Issues
1. WiFi won't connect:
  - Check SSID and password
  - Verify router compatibility
  - Check signal strength
2. MQTT won't connect:
  - Verify broker address
  - Check internet connectivity
  - Try alternative brokers
3. No sensor data:
  - Check LDR connections
  - Verify LDR pin assignment
  - Test with multimeter

#### Upload Issues
1. Port not found:
  - Install USB drivers
  - Check cable connection
  - Try different USB port
2. Upload fails:
  - Press reset button during upload
  - Check bootloader mode
  - Try lowering upload speed

---

## 🌐 MQTT Configuration

### Topic Structure

All topics follow the structure: lumisense/esp32_001/<category>/<subcategory>

#### Publish Topics (ESP32 → Flutter)
|Topic|	Payload|	Description|
|-----|--------|-------------|
|lumisense/esp32_001/telemetry/ldr|	Integer (0-1023)|	Current LDR value|
|lumisense/esp32_001/status|	JSON String|	Device status and health|
|lumisense/esp32_001/mode|	"auto" or "manual"	|Current operating mode|
|lumisense/esp32_001/brightness	|Integer (0-255)|	Current brightness|
|lumisense/esp32_001/led_status	|JSON String|	Individual LED status|

#### Subscribe Topics (Flutter → ESP32)
|Topic|	Payload|	Description|
|-----|--------|-------------|
|lumisense/esp32_001/command/mode|	"auto" or "manual"	|Change operating mode|
|lumisense/esp32_001/command/brightness|	Integer (0-255)	|Set all LEDs brightness|
|lumisense/esp32_001/command/threshold|	Integer (0-1023)	|Set LDR threshold|
|lumisense/esp32_001/command/led|	"on" or "off"	|Turn all LEDs on/off|
|lumisense/esp32_001/command/led_color|	"color,brightness"|	Control individual LED|

#### Payload Examples
Device Status (JSON):
```bash
{
  "online": true,
  "uptime": "01:23:45",
  "ip": "192.168.1.100",
  "rssi": -45,
  "mode": "auto",
  "ldr": 512,
  "brightness": 128
}
```
LED Status (JSON):
```bash
{
  "red": {"on": true, "brightness": 128},
  "green": {"on": false, "brightness": 0},
  "yellow": {"on": true, "brightness": 64},
  "white": {"on": false, "brightness": 0},
  "blue": {"on": true, "brightness": 255},
  "orange": {"on": false, "brightness": 0}
}
```
LED Color Command:
```bash
red,128    # Set red LED to 50% brightness
blue,255   # Set blue LED to 100% brightness
white,0    # Turn off white LED
```
#### Testing with MQTT Explorer
1. Download MQTT Explorer: mqtt-explorer.com
2. Connect:
   -  Host: broker.hivemq.com
   -  Port: 1883
3. Subscribe: lumisense/#
4. Publish Test:
   -  Topic: lumisense/esp32_001/command/led
   -  Payload: on

---

## 📸 Screenshots

### Dashboard

```
┌────────────────────────────────────────────────────────────────────┐
│  [Dashboard] [History] [Settings]                     [🔵] [🔄]   │
├────────────────────────────────────────────────────────────────────┤
│         ┌──────────────────────┐  ┌──────────────────────┐         │
│         │  MQTT Status         │  │  Device Status       │         │
│         │  ● Connected         │  │  ● Online            │         │
│         │  broker.hivemq.com   │  │  Uptime: 01:23:45    │         │
│         └──────────────────────┘  └──────────────────────┘         │
│                                                                    │
│  ┌──────────────────────────────────────────────────────────────┐  │
│  │  LDR Value                                                   │  │
│  │  512                   ☀️                                    │  │
│  │  Bright Room                                                 │  │
│  │  [████████████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░]   │  │
│  │  0                      512                      1023        │  │
│  └──────────────────────────────────────────────────────────────┘  │
│                                                                    │
│         ┌──────────────────────┐  ┌──────────────────────┐         │
│         │  LED Control         │  │  Mode Control        │         │
│         │  Status: ON          │  │  Auto Mode           │         │
│         │  [ON/OFF]            │  │  [Auto/Manual]       │         │
│         └──────────────────────┘  └──────────────────────┘         │
│                                                                    │
│  ┌──────────────────────────────────────────────────────────────┐  │
│  │  Brightness                                                  │  │
│  │  50%                                                         │  │
│  │  [███████████████████████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░]  │  │
│  │  0%                         50%                        100%  │  │
│  └──────────────────────────────────────────────────────────────┘  │
│                                                                    │
│  ┌──────────────────────────────────────────────────────────────┐  │
│  │  LDR Threshold                                               │  │
│  │  500                                                         │  │
│  │  [███████████████████████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░]  │  │
│  │  Dark                      500                       Bright  │  │
│  └──────────────────────────────────────────────────────────────┘  │
└────────────────────────────────────────────────────────────────────┘
```
### History
```
┌────────────────────────────────────────────────────────────────────┐
│  [Dashboard] [History] [Settings]                    [📊] [📥]    │
├────────────────────────────────────────────────────────────────────┤
│  ┌──────────────────────────────────────────────────────────────┐  │
│  │  Statistics                                                  │  │
│  │  ┌──────┐  ┌──────┐  ┌──────┐  ┌──────┐                      │  │
│  │  │ 512  │  │ 980  │  │ 45   │  │ 124  │                      │  │
│  │  │ Avg  │  │ Max  │  │ Min  │  │ Rec  │                      │  │
│  │  └──────┘  └──────┘  └──────┘  └──────┘                      │  │
│  └──────────────────────────────────────────────────────────────┘  │
│                                                                    │
│  ┌──────────────────────────────────────────────────────────────┐  │
│  │  LDR Value History                                           │  │
│  │         ╭────╮                                               │  │
│  │    ╭────╯    ╰───╮                                           │  │
│  │   ╭╯             ╰──╮                                        │  │
│  │  ╭╯                 ╰──╮                                     │  │
│  │ ╭╯                     ╰─╮                                   │  │
│  │                          ╰────╮                              │  │
│  │                               ╰────                          │  │
│  │  10:00  10:15  10:30  10:45  11:00                           │  │
│  └──────────────────────────────────────────────────────────────┘  │
│                                                                    │
│  ┌──────────────────────────────────────────────────────────────┐  │
│  │  Recent History                                              │  │
│  │  ┌────────────────────────────────────────────────────────┐  │  │
│  │  │  LDR: 512    Brightness: 128    Auto    10:30:15       │  │  │
│  │  ├────────────────────────────────────────────────────────┤  │  │
│  │  │  LDR: 480    Brightness: 128    Auto    10:30:00       │  │  │
│  │  ├────────────────────────────────────────────────────────┤  │  │
│  │  │  LDR: 450    Brightness: 150    Auto    10:29:45       │  │  │
│  │  ├────────────────────────────────────────────────────────┤  │  │
│  │  │  LDR: 520    Brightness: 100    Auto    10:29:30       │  │  │
│  │  └────────────────────────────────────────────────────────┘  │  │
│  └──────────────────────────────────────────────────────────────┘  │
└────────────────────────────────────────────────────────────────────┘
```
### Settings
```
┌─────────────────────────────────────────────────────────────────────┐
│  [Dashboard] [History] [Settings]                                   │
├─────────────────────────────────────────────────────────────────────┤
│  ═══════════════════════════════════════════════════════════════    │
│  ● Auto Mode                                                        │
│    Automatically adjust brightness          [✓]                     │
│  ─────────────────────────────────────────────────────────────────  │
│  ● Enable Notifications                                             │
│    Receive notifications about light changes  [✓]                   │
│  ─────────────────────────────────────────────────────────────────  │
│  ─────────────────────────────────────────────────────────────────  │
│  🗑  Clear History                                                   │
│     Remove all history data                                         │
│  ─────────────────────────────────────────────────────────────────  │
│  ─────────────────────────────────────────────────────────────────  │
│  ℹ  About                                                           │
│     LumiSense v1.0.0                                                │
│     MIT License                                                     │
│  ─────────────────────────────────────────────────────────────────  │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 🐛 Troubleshooting

### Common Issues and Solutions
#### Issue 1: Flutter App Cannot Connect to MQTT
##### Symptoms:
   - "Error: Exception: MQTT connection error"
   - "SocketException: Failed host lookup"
##### Solutions:
1. Check internet connectivity
2. Verify broker address: broker.hivemq.com
3. Try IP address: 52.48.82.151
4. Check firewall settings
5. Try alternative brokers:
   - test.mosquitto.org
   - broker.emqx.io

#### Issue 2: ESP32 Not Publishing Data
##### Symptoms:
   - Serial monitor shows no LDR readings
   - Flutter app shows 0 for LDR value
##### Solutions:
1.Verify LDR connections
2. Check LDR pin assignment (D8)
3. Test LDR with multimeter
4. Ensure analog reading works:
```bash
Serial.println(analogRead(LDR_PIN));
```
#### Issue 3: ESP32 Not Connecting to WiFi
##### Symptoms:
   - Serial monitor shows "WiFi connection failed"
   - IP address is 0.0.0.0
##### Solutions:
1. Verify SSID and password in config.h
2. Check router compatibility
3. Verify WiFi signal strength
4. Try different network

#### Issue 4: LEDs Not Working
##### Symptoms:
   - LED Manager initialized but LEDs don't light up
##### Solutions:
1. Verify LED connections
2. Check resistor values (220Ω)
3. Verify pin assignments in config.h
4. Test with simple blink sketch:
```bash
pinMode(D0, OUTPUT);
digitalWrite(D0, HIGH);
```
#### Issue 5: MQTT Messages Not Received
##### Symptoms:
   - Flutter app subscribed but no messages
##### Solutions:
1. Verify topic structure matches
2. Check MQTT connection status
3. Use MQTT Explorer for testing
4. Verify QoS levels

---

## 🚀 Future Improvements

### Planned Features
- Multi-device Support: Manage multiple ESP32 devices
- Cloud Sync: Backup and restore settings
- Voice Control: Integration with Alexa/Google Assistant
- Energy Monitoring: Track power consumption
- Machine Learning: Predictive automation
- Web Dashboard: Browser-based control
- OTA Updates: Over-the-air firmware updates
- Weather Integration: Automatic adjustment based on weather
- User Authentication: Multi-user support
- Push Notifications: Cloud-based notifications
- Custom Scenes: Pre-defined lighting scenes
- Scheduling: Time-based automation
- Energy Savings: Optimized lighting schedules
### Technical Improvements
- Unit Testing: Comprehensive test coverage
- Integration Testing: End-to-end testing
- Performance Optimization: Reduced latency
- Security: TLS/SSL encryption
- Offline Mode: Local control without internet
- Data Analytics: Advanced visualization
- BLE Support: Bluetooth Low Energy fallback
- FOTA: Firmware OTA for ESP32

---

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. Fork the repository
2. Create a feature branch:
```bash
git checkout -b feature/amazing-feature
```
3. Commit changes (Conventional Commits):
```bash
git commit -m "feat: add amazing feature"
```
4. Push to branch:
```bash
git push origin feature/amazing-feature
```
5. Open a Pull Request

### Commit Convention
We use Conventional Commits:
 - feat: New feature
 - fix: Bug fix
 - docs: Documentation
 - style: Code style
 - refactor: Code refactoring
 - perf: Performance improvement
 - test: Testing
 - chore: Build/CI/CD

### Code Quality Guidelines
 - Follow Dart/Flutter best practices
 - Write meaningful commit messages
 - Add comments where necessary
 - Update documentation
 - Test your changes

---

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.
```bash
MIT License

Copyright (c) 2026 LumiSense

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
