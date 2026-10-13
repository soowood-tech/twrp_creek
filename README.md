# TWRP Recovery for Redmi (Creek / Snapdragon 680 - SM6225)

Custom TeamWin Recovery Project (TWRP) build with full touch support and dynamic partitions for **Redmi (codename: `creek` / `creek_global`)** based on Qualcomm Snapdragon 680 (SM6225 / `khaje`).

---

## 📱 Device Specifications

| Parameter | Details |
| :--- | :--- |
| **Device Codename** | `creek` / `creek_global` (SM6225 / `khaje` platform) |
| **Target OS** | Android 13 / 14 / HyperOS |
| **Partition Scheme** | Virtual A/B (VAB) with Dynamic Partitions (`super`) |
| **Filesystems Supported** | EROFS, F2FS, EXT4, VFAT |
| **Recovery Partition** | Dedicated `recovery` partition (`/dev/block/bootdevice/by-name/recovery`) |

---

## ✨ Features & Fixes

* **Working Touchscreen (Touch Fix)**:
  - Resolved the common "no touch" issue on `creek` by injecting and loading vendor touchscreen kernel modules:
    - `focaltech_ts_i2c.ko`
    - `td4376_spi.ko`
    - `xiaomi_tp.ko` / `lct_tp.ko`
    - `spi-msm-geni.ko`
    - `panel_event_notifier.ko`
* **Dynamic Partitions Support**:
  - Full support for EROFS and EXT4 logical partitions inside `super`:
    - `/system`, `/system_ext`, `/product`, `/vendor`, `/odm`, `/vendor_dlkm`, `/system_dlkm`
* **Storage & Decryption**:
  - F2FS support for `/data` and `/metadata`.
* **Hardware Features**:
  - Haptic feedback (`vibratorfeature-hal-service`).
  - Flashlight control symlinks (`sysfs`).
  - ADB & MTP functional during recovery mode.

---

## 🚀 Installation & Flashing

### Prerequisites:
- Unlocked bootloader.
- `adb` and `fastboot` installed on PC.
- Device connected in Fastboot mode (`Power` + `Volume Down`).

### Flashing via Fastboot:

```bash
# 1. Verify device detection
fastboot devices

# 2. Flash recovery to the recovery partition
fastboot flash recovery twrp_creek_universal_fixed.img

# 3. Boot directly into TWRP
fastboot reboot recovery
```

> **Note:** If your device uses A/B slots, you can flash both slots explicitly:
> ```bash
> fastboot flash recovery_a twrp_creek_universal_fixed.img
> fastboot flash recovery_b twrp_creek_universal_fixed.img
> ```

---

## 📂 Repository Structure

```
├── build_final/               # Finalized recovery artifacts, fstab & splash config
│   ├── recovery.fstab         # Partition table mounts (EROFS, F2FS, EXT4)
│   ├── splash.xml             # TWRP UI theme & splash
│   └── twrp_cli               # CLI utilities
├── twrp_patch_build/          # Kernel modules & init scripts injection
│   ├── init.recovery.qcom.rc  # Init script with touch module loading
│   ├── modules.load.recovery  # List of recovery kernel drivers
│   └── modules.dep            # Kernel module dependency tree
├── magiskboot                 # Magiskboot binary for unpacking & repacking boot/recovery
└── README.md                  # Documentation
```

---

## 🛠️ Credits & Acknowledgments

- **TeamWin** for TeamWin Recovery Project ([TWRP](https://twrp.me/))
- **OrangeFox Recovery Project** for driver references
- **topjohnwu** for `magiskboot`
- Maintained & patched by **soowood-tech**
