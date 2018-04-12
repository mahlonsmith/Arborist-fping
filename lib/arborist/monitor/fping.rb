# -*- ruby -*-
# vim: set noet nosta sw=4 ts=4 :
# encoding: utf-8
#
# This library parses fping output when provided a list of nodes to
# monitor.  Require it from your monitor file(s), and call the Arborist
# exec() with this class -- that's it.
#
#    require 'arborist/monitor/fping'
#
#    Arborist::Monitor 'ping check' do
#        every 20.seconds
#        match type: 'host'
#        exec 'fping', '-e', '-t', '150'
#        exec_callbacks( Arborist::Monitor::FPing )
#    end


require 'loggability'
require 'arborist/monitor' unless defined?( Arborist::Monitor )

# Parse Fping output for better batch ICMP checks.
#
module Arborist::Monitor::FPing
	extend Loggability
	log_to :arborist

	# The version of this library.
	VERSION = '0.1.2'

	# Always request the node addresses.
	USED_PROPERTIES = [ :addresses ].freeze

	### Return the properties used by this monitor.
	def self::node_properties
		return USED_PROPERTIES
	end

	attr_accessor :identifiers

	### Arborist::Monitor API: Send addresses to the fping binary, after
	### creating a map to re-associate them back to identifiers.
	###
	def exec_input( nodes, io )
		self.log.debug "Building fping input for %d nodes" % [ nodes.size ]
		self.identifiers = nodes.each_with_object({}) do |(identifier, props), hash|
			next unless props.key?( 'addresses' )
			address = props[ 'addresses' ].first
			hash[ address ] = identifier
		end

		return if self.identifiers.empty?

		self.identifiers.keys.each{|ip| io.puts(ip) }
	end


	### Parse fping output, return a hash of RTT data, along
	### with any detected errors.
	###
	def handle_results( pid, stdout, stderr )
		# 8.8.8.8 is alive (32.1 ms)
		# 8.8.4.4 is alive (14.9 ms)
		# 1.1.1.1 is alive (236 ms)
		# 8.8.0.1 is unreachable

		return stdout.each_line.with_object({}) do |line, hash|
			address, remainder = line.split( ' ', 2 )
			identifier = self.identifiers[ address ] or next

			if remainder =~ /is alive \((\d+(?:\.\d+)?) ms\)/
				hash[ identifier ] = { rtt: Float( $1 ) }
			else
				hash[ identifier ] = { error: remainder.chomp }
			end
		end
	end
end # Arborist::Monitor::FPing

