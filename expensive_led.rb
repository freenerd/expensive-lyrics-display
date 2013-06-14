$LOAD_PATH << '/tmp/launchpad/launchpad/lib'
require 'launchpad'
require 'json'

class TextScroller
  #SYNC_DELAY = 0.720
  SYNC_DELAY = 0.450
  SPEED = 7
  FEED_IN = 6
  FEED_FIXES = 3
  GRID_WIDTH = 9

  def initialize(input)
    @devices = []
    @input = input
    @threads = []

    setup_devices
  end

  def reset
    @devices.each do |device|
      device.marque("", 0, SPEED)
      device.reset
    end
  end

  def close
    @devices.each do |device|
      device.reset
      device.close
    end
  end

  def get_offset(launchpad_index)
    if launchpad_index < FEED_IN
      GRID_WIDTH * (FEED_IN - launchpad_index) + FEED_FIXES
    else
      0
    end
  end

  def get_sync_delay(launchpad_index)
    launchpad_index < FEED_IN ? 0 : SYNC_DELAY
  end

  def output(text)
    reset

    @thread.kill if @thread

    @threads = Thread.new do
      p "Printing #{text}"

      @devices.each_with_index do |device, launchpad_index|
        offset = get_offset(launchpad_index)
        sync_delay = get_sync_delay(launchpad_index)

        device.marque(text, offset, SPEED)
        sleep(sync_delay)
      end
    end
  end

  def run
    def now; Time.now.to_f; end
    start = now

    while true do
      time = @input.next_time
      if now > (start + time)
        line = @input.next
        output(line)
      end

      sleep 0.05
    end
  end

  private

  # Launchpads are setup in order of their Launchpad S id
  def setup_devices
    def create_device(device)
      Launchpad::Device.new(
        :output_device_id => device.device_id,
        :input => false)
    end

    device_ids = []
    Portmidi.output_devices.each do |device|
      device_ids << device.name

      match = device.name.match(/Launchpad S (\d?)/)
      if match && !match[1].empty?
        # it's one of the many Launchpads with numbers
        @devices[match[1].to_i] = create_device(device)
      else
        # it's the first Launchpad with name "Launchpad S"
        @devices[1] = create_device(device)
      end
    end

    unless @devices.length == (@devices.compact.length + 1) # index starts at 1
      raise "Something went wrong with collecting devices. \
             Make sure that their IDs are sequential, by selecting them on boot. #{device_ids}"
    end

    @devices.compact!
  end
end

class TextScrollerInput
  def initialize
    @lyrics = nil
    @counter = 0
  end

  def load_lyrics_test
    @lyrics = [
        { :time => 0, :text => "Harder" },
        { :time => 2.200, :text => "Faster" },
        { :time => 4.000, :text => "Better" },
        { :time => 7.000, :text => "Stronger" }
      ]

    #@lyrics = [
        #{ :time => 0, :text => "Stronger" },
        #{ :time => 3.000, :text => "Stronger" },
      #]

    self
  end


  def load_lyrics_file
    @lyrics = JSON.parse(File.read("daftpunk_harder.json")).map do |line|
      { :time => line["time"]["total"] - 50, :text => line["text"] }
    end

    self
  end

  def next_time
    ensure_counter

    @lyrics[@counter][:time]
  end

  def next
    ensure_counter

    output = @lyrics[@counter][:text]
    @counter += 1
    output
  end

  private

  def ensure_counter
    raise "No lyrics loaded" unless @lyrics
    if @counter >= @lyrics.length
      # start from beginning
      @counter = 0
    end
  end
end

text_scroller = TextScroller.new(
  TextScrollerInput.new.load_lyrics_file
)

trap("SIGINT") { text_scroller.close; exit }

text_scroller.run
