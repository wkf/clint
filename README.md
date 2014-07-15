#Clint

Clint helps you build smallish command line applications in bash (if you want). It's inspired (heavily) by [docopt](http://docopt.org/), but it's written in pure bash and does less. Like docopt, clint parses the documentation string and then parses the command line from that information. Since the documentation is used to build the parser, it's much harder for it to get stale. Clint also handles a fair number of boring details, like checking for unknown commands/options, and automatically generating help/version responses.

#Example

Here's a working example of how to use clint:

	#!/usr/bin/env bash
	
	# A working example of parsing command line options with clint.
	#
	# Try some of these:
	#
	#   example.bash --help                          #-> handles --help and --version options (if defined)
	#   example.bash version                         #-> handles help/version commands too (if defined)
	#   example.bash --fudge                         #-> error, no fudge here
	#   example.bash print hello                     #-> prints hello 2 times (the default)
	#   example.bash print --times=7 "hello there"   #-> prints "hello there" 7 times
	#
	# Good luck.
	
	set -o nounset
	set -o errtrace
	set -o pipefail
	
	source lib/clint.bash
	
	example() {
	  clint_start "$@" <<EOF
	
	  usage: example.bash [options] <command> [<arguments>...]
	
	  commands:
		print			  print the message
		help			   print help
		version			print version
	
	  options:
		-h, --help		 display this message
		-v, --version	  display version information
	
	  version: 0.0.1
	
	EOF
	
	  example_"$(clint_command)"
	}
	
	example_print() {
	  clint_continue <<EOF
	
	  usage: example.bash print [options] <message>
	
	  options:
		-t N, --times=N  print this many times [default: 2]
		-h, --help
		-v, --version

	EOF
	
	  local times="$(clint_option --times)"
	  local message="$(clint_parameter message)"
	
	  for i in $(seq 1 $times); do
		echo "$message"
	  done
	}
	
	example "$@"
	
#Tests

To run the clint test suite, install [bats](https://github.com/sstephenson/bats) and run ```bats test/clint.bats```.