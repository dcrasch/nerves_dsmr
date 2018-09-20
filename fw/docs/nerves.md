# Nerves


## Update firmware

$ mix firmware.push powerpi

## Or generate firmware upload script

$ mix firmware.gen.script

## Check log raspberry pi

$ ssh powerpi

iex(1)> RingLogger.tail

more info:
iex(4)> h(RingLogger)

exit:
<RETURN>
~.

## Reboot

ssh powerpi

iex(1) > Nerves.Runtime.reboot
