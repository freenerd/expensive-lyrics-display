# Expensive LED Scrolling Strip

## What?
This is a script that shows lyrics on several Novation Launchpad S. It uses the built-in scrolling functionality of the launchpad, but delays and offsets the messages to show them scrolling over many pads. To enable offset to make the text start in the middle of the display, we patched the Launchpad firmware.

The software was developed by @freenerd at Music Hack Day Barcelona 2013 with lots of help of Ross from Novation, who wrote the firmware patch. Also the synced lyrics came from MusixMatch.

A video demonstration can be seen here:
https://www.youtube.com/watch?v=AcOoXeCA_-8

## Requirements

  * 1-16 Novation Launchpad S
  * Ruby 1.9.3
  * Portmidi

## Installation & Setup
  Install portmidi. If you are on a Mac and have Homebrew, do `brew install portmidi`.

  To install all the dependent gems, use bundler with `bundle install`.

  Connect all the Launchpads you have (i hope it's many!) to your computer. To make use of the offset functionality, you have to put our patched firmware on each. Please refer to the Launchpad manual, on how to do that.

  Every Launchpad needs a unique sequential device id. To do this, while connecting each Launchpad hold down the session, user1, user2 and mixer buttons. You can then choose the ID of the Launchpad via the top yellow buttons, with 1 in the top left corner and 16 in the bottom right.

  Next: run it!

## Run
  To run, you obviously need text to be displayed, together with timing information. You can either fill them by hand in the `TextScrollerInput.load_lyrics_test` method or load a file via the `TextScrollerInput.load_lyrics_file` method. As an example for a file, look at the `daftpunk_harder.json` which has the first lines of the lyrics, as also shown in the demo video.

  You can also use the websockets, as explained below.

  If you want to have music played along the lyrics, uncomment the lines at the bottom of the file. This will only work on Mac, since it uses the afplay tool. You have to provide the audio file yourself.

  Once setup run `ruby expensive_led.rb`

## More explanation
This only works with the Launchpad S, since the original Launchpad 1 doesn't have a built-in text scrolling functionality.

The text scrolling is well-explained in the Novation Launchpad S Programmers manual. Check it here:

http://global.novationmusic.com/support/product-downloads?product=Launchpad+S
https://d19ulaff0trnck.cloudfront.net/sites/default/files/novation/downloads/4700/launchpad-s-prm.pdf

We patched the firmware. You can also use it unpatched, but then the lyrics always start to scroll from the first launchpad with no text visible when each lyric line starts.

## Websocket support
We also implented websocket support on the basis of SocketIO. You can enable it by uncommenting some code on the bottom of the file. The client respnds to events of 'linechanged' with the structure `{"lyrics": "Your line to display"}`.
