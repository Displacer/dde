require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module DDETest

  DDE_DATA = "\x10\x00\x04\x00\b\x00\t\x00\x02\x00\t\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x18\x00fffff\x8Ee@\x00\x00\x00\x00\x00y\xB7@\x00\x00\x00\x00\x80b\xC1@\x02\x00\x01\x00\x00\x01\x00(\x00\x9A\x99\x99\x99\x99\x99\xB9?q=\n\xD7\xA3\x98e@)\\\x8F\xC2\xF5`e@\\\x8F\xC2\xF5(\x8Ce@H\xE1z$XLZA\x01\x00H\x00q=\n\xD7\xA3\x88e@\x00\x00\x00\x00\x80\xED\xC9@\x00\x00\x00\x00\x00\x00\x00\x00\xB8\x1E\x85\xEBQ e@{\x14\xAEG\xE1z\xF4?\xAEG\xE1z\x14\xCEe@\xA4p=\n\xD7\ve@H\xE1z\x14\xAE\x7Fe@\x00\x00\x80\x94\xC0-\aB\x01\x00H\x00ffff&\xF4\xB2@\x00\x00\x00\x00\x00P\x91@\x00\x00\x00\x00\x00\x00\x00\x00=\n\xD7\xA30\xA2\xB2@ffffff\xEE?\x00\x00\x00\x00\x00$\xB3@\x00\x00\x00\x00\x00\x9A\xB2@=\n\xD7\xA3\xF0\xE1\xB2@\x00\x00\x90\x9DEy\xF0A\x01\x00H\x00\x00\x00\x00\x00\x00\xD0m@\x00\x00\x00\x00\x00\xF9\xBE@\x00\x00\x00\x00\x00\x00\x00\x00\x9A\x99\x99\x99\x99\x99m@\xB8\x1E\x85\xEBQ\xB8\xAE?H\xE1z\x14\xAE\xFFm@\x00\x00\x00\x00\x00hm@\xECQ\xB8\x1E\x85\xC3m@\x00\x00\xC0\x8Fp\x80\xE6A\x01\x00H\x00\xCD\xCC\xCC\xCC\xCC\xBCT@\x00\x00\x00\x00\x80\xAF\xE7@\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x90T@{\x14\xAEG\xE1z\xA4?fffff\xE6T@\x9A\x99\x99\x99\x99YT@\x1F\x85\xEBQ\xB8\xAET@\x00\x00t\x80r<\x12B\x01\x00\b\x00\xF6(\\\x8F\xC2\n\x97@\x02\x00\b\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00H\x00\x83\xC0\xCA\xA1E\xB6\xB3?\x00\x00\x00\x00 \xC8\xF1@\x00\x00\x00\x00\x00\x00\x00\x00@\xA4\xDF\xBE\x0E\x9C\xB3?\xA4p=\n\xD7\xA3\xC0?\t\xF9\xA0g\xB3\xEA\xB3?\xBAk\t\xF9\xA0g\xB3?r\xF9\x0F\xE9\xB7\xAF\xB3?\x00\x00 \xBC\xA35\xE9A"
  DRAW_OUTPUT = "-----
[G]V
[G]V 172.45 6009 8901  0.1 172.77 171.03 172.38 6893920.57
[G]V 172.27 13275 0 169.01 1.28 174.44 168.37 171.99 12443980432
[G]V 4852.15 1108 0 4770.19 0.95 4900 4762 4833.94 4422130137
[G]V 238.5 7929 0 236.8 0.06 239.99 235.25 238.11 3020129406
[G]V 82.95 48508 0 82.25 0.04 83.6 81.4 82.73 19580887069
[G]V 1474.69
[G]V 0.077 72834 0 0.0766 0.13 0.0778 0.0758 0.0769 3383565793
Last: 8 in 0.0 s(0.0 s/rec), total: 8 in  0.0 s(0.0 s/rec)"

  describe DDE::XlTable do
    before(:each) {@data = DDE::XlTable.new}

    it 'starts out empty and without topic' do
      @data.should be_empty
      @data.topic.should == nil
    end

    context 'with server/client pair and started conversation' do
      before(:each )do
        start_callback_recorder do|*args|
          @server_calls << extract_values(*args)
          if args[0] == XTYP_POKE
            p extract_values(*args)
            @data.receive(args[5]) #, :debug)
          end
          DDE_FACK
        end
        @client.start_conversation 'service', 'topic'
      end

      after(:each ){stop_callback_recorder}

      it 'starts out empty and without topic' do
        pending
        @client.send_data DDE_DATA, CF_TEXT, "item"
        @data.should_not be_empty
        @data.topic.should == nil
        @data.draw.should == nil
      end
    end

  end

end