# Arborist-fping

home
: http://bitbucket.org/mahlon/Arborist-fping

code
: http://code.martini.nu/Arborist-fping

fping
: http://fping.org/


## Description

Arborist is a monitoring toolkit that follows the UNIX philosophy
of small parts and loose coupling for stability, reliability, and
customizability.

This adds fping sweeping support to Arborist monitoring, which is an
efficient means to check the ICMP reachability of many, many hosts
simultaneously.

It requires the fping binary to be installed in your path.  Use your
package manager of choice.


## Prerequisites

* Ruby 2.2 or better


## Installation

    $ gem install arborist-fping


## Usage

In this example, we're using ICMP reachability as the method to
determine if a host node is available/present on network.

	Arborist::Host( 'example' ) do
		description "Example host"
		address     '10.6.0.169'
	end


From a monitor file, require this library, and exec() to fping.  We'll
record RTT per node in this example with the -e flag, and lower the
timeout-per-host:

	require 'arborist/monitor/fping'

	Arborist::Monitor 'ping check' do
		every 10.seconds
		match type: 'host'
		include_down true
		use :addresses
		exec 'fping', '-e', '-t', '150'
		exec_callbacks( Arborist::Monitor::FPing )
	end

That's it.


## License

Copyright (c) 2016, Michael Granger and Mahlon E. Smith
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice,
  this list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.

* Neither the name of the author/s, nor the names of the project's
  contributors may be used to endorse or promote products derived from this
  software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


