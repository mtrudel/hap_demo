# HAP Demo

This project is an example of how to use the [HAP](https://github.com/mtrudel/hap) library
to create HomeKit controllable software using Elixir & Nerves. This example is focused on RPi
and wires up a GPIO pin to represent a light bulb. To demonstrate asynchronous notifcations you
may send messages to the GPIO module like so:

```
HAPDemo.GPIO.toggle(22)
```

These changes will be reflected in real-time within any HomeKit controller that lists the light
bulb service.

# Usage

As a demonstration project, this project is intended to be run on a Raspberry Pi of
just about any flavour (it should also run on other Nerves targets with minor changes to
GPIO pin numbers). To install & run it, simply:

  * Ensure you have the supported Erlang & Elixir versions installed. See [Nerves' excellent
    documentation](https://hexdocs.pm/nerves/installation.html) for help with this.
  * Install HAP and other dependencies by running `MIX_TARGET=rpi_0 mix deps.get`
  * Create firmware with `MIX_TARGET=rpi_0 mix firmware`
  * Burn to an SD card with `MIX_TARGET=rpi_0 mix firmware.burn`
  * Configure your Nerves target to connect to your local network (again, consult [Nerves'
    documentation](https://hexdocs.pm/vintage_net/readme.html) on the matter).
  * Connect to the console of your Nerves target. If the QR / Pairing code is not visible, 
    you can regenerate it by running `HAP.Display.update_pairing_info_display()`.
  * Use the Home app on your iOS device to connect to the Nerves device by scanning 
    the QR code or manually entering the pairing code.

Note that HAP has a hard requirement for OTP 23 or greater due to the availability of 
certain crypto routines. If you use asdf to host your Erlangs, the `.tool-versions` file
in this project will take care of you; just run `asdf install` in this folder and you 
should be good to go.

# License

MIT
