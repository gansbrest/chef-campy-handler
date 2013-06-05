#!/usr/bin/env ruby
# Chef Exception & Reporting Handler for Campfire.
#
# Author:: Sergey Khaladzinski
#

require 'rubygems'
require 'chef/handler'
require 'campy'

class Chef
  class Handler
    class Campfire < Chef::Handler

      def initialize(attr)
        @subdomain = attr[:subdomain]
        @token = attr[:token]
        @room = attr[:room_id]
      end

      def report
        campy = Campy::Room.new(:account => @subdomain,
                                :token => @token, :room_id => @room)

        time = Time.new
        timestamp = time.inspect

        icon = ':white_check_mark:'
        msg_prefix = 'LOG: ' + node.hostname + ' [' + timestamp + '] Elapsed time: ' + run_status.elapsed_time.round(2).to_s + 's Updated resources: ' + run_status.updated_resources.length.to_s

        if run_status.failed?
          icon = ':exclamation:'
          Chef::Log.error('Creating Campfire exception report.')
          campy.speak( icon + ' ' + msg_prefix + ' Msg: ' + run_status.formatted_exception)
          campy.paste(Array(backtrace).join('\n'))
        else
          campy.speak( icon + ' ' + msg_prefix + ' Msg: Chef client run successfully')
        end
      end
    end
  end
end
