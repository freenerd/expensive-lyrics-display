# Expensive LED Scrolling Strip

## What?

This is a script that shows lyrics on several Novation Launchpad S. It uses the built-in scrolling functionality of the launchpad, but delays and offsets the messages to show them scrolling over many pads. To enable offset, we patched the Launchpad firmware.

It was developed by @freenerd at Music Hack Day Barcelona 2013 with lots of help of Ross from Novation, who wrote the firmware patch.

A video demonstration can be seen here:
http://youtu.be/tJrzez5E6EI

## Requirements

  1-16 Novation Launchpad S

  Ruby 1.9.3
  Portmidi

## More explanation

This only works with the Launchpad S, since the original Launchpad 1 doesn't have a built-in text scrolling functionality.

The text scrolling is well-explained in the Novation Launchpad S Programmers manual. Check it here:

http://global.novationmusic.com/support/product-downloads?product=Launchpad+S
https://d19ulaff0trnck.cloudfront.net/sites/default/files/novation/downloads/4700/launchpad-s-prm.pdf

## Installation & Setup
  Install portmidi. If you are on a Mac and have Homebrew, do `brew install portmidi`.

  To install all the dependent gems, use bundler with `bundle install`.

  Connect all the Launchpads to your computer. To make use of the offset functionality, you have to put our patched firmware on each. Please refer to the Launchpad manual, on how to do that.

  Every Launchpad needs a unique sequential device id. To do this, while connecting each Launchpad hold down the session, user1, user2 and mixer buttons. You can then choose the ID of the Launchpad via the top yellow buttons, with 1 in the top left corner and 16 in the bottom right.

## Run
  to be written

## Websocket support
  to be written
