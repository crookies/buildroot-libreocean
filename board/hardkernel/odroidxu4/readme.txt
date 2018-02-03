Odroid XU-4 board with Samsung Exynos 5422 SoC

Introduction
------------

The Odroid XU 4 board is developed and shipped by Hrdkernel (hardkernel.com). It
uses the Samsung Exynos 5422 Soc.

Odroid boot process
-------------------

The odroid boot process requires three stages of boot plus trust zone:

    boot level 1

        |
        V

    boot level 2

        |
        V

     u-boot

and they need to be raw copied to the SD card in the following order:

    +----------------+----------------+
    | boot level 1   | 1 block        |
    +----------------+----------------+
    | boot level 2   | 31 block       |
    +----------------+----------------+
    | u-boot         | 63 block       |
    +----------------+----------------+
    | trust zone     | 2111 block     |
    +----------------+----------------+
    | boot partition | 4096 block     |
    +----------------+----------------+
    | rootfs         |                |
    +----------------+----------------+


How to build it
===============

  $ make odroidxu4_defconfig

Then you can edit the build options using

  $ make menuconfig

Compile all and build rootfs image:

  $ make

Note: you will need to have access to the network, since Buildroot will
download the packages' sources.

Result of the build
-------------------

After building, you should obtain all output files in output/images/


How to write the SD card or eMMC
================================

Once the build process is finished you will have an image called "sdcard.img"
in the output/images/ directory.

Copy the bootable "sdcard.img" onto an SD card or eMMC with "dd":

  $ sudo dd if=output/images/sdcard.img of=/dev/sdX

Insert the SDcard into your ODROID-XU4, and power it up. Your new system
should come up now.
