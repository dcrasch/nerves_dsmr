# Serial testing with test messages
## create virtual serial ports
socat pty,raw,echo=0,link=/tmp/vmodem1  pty,raw,echo=0,link=/tmp/vmodem0

in other screen:
socat FILE:example-telegram.txt /tmp/vmodem1

## example-telegram.txt
\r\n at the end of line!
