#!/usr/bin/ruby
#
# Copyright (c) 2012 Chris Devereux
# All rights reserved.

# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met: 

# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer. 
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution. 

# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
# ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

if ARGV.count < 2 then
	$stderr.puts "Usage: nstool [library-path] [namespace-suffix] <[filtered-prefixes] ...>"
	exit
end

library_path, namespace_suffix = ARGV
filter_prefixes = ARGV[2..-1] ||= []


# Outputs content for a header file defining macros that alias class, symbol and
# protocol names.

# This allows an objective-c library to be embedded privately in other libraries
# without causing a name collision if a library user also links to that library.

# Arguments: 
# * library-path: Path to a .dylib or .a library 
# * namespace-suffix: String appended to all symbol names. 
# * filtered-prefixes: Optional list of prefixes to classes and functions that should
#     not be aliased (eg. NS and UI).

# Inspired by a similar feature in NimbusKit.


# get all exported symbols
symbols = `nm #{library_path}`.grep(/\w+ (S|T|C|A|D|I)/)

# Remove methods and any compiler-generated runtime support
symbols.reject!{|x| 
	x.match(/_objc_|_OBJC_IVAR_|\[/)
}

# get the identifiers
identifiers = symbols.map{|x|
	x.match(/_(\w+)$/)
}.reject{|x| 
	x == nil
}.map{|x|
	x[1]
}

# filter prefixes
filtered = identifiers.reject{|x|
	filter_prefixes.any?{|y| x.match(/^#{y}/) }
}

# spit out the file

puts "#ifdef #{namespace_suffix}"
puts ""

filtered.uniq.each{|x|
	puts "#define #{x} #{x}###{namespace_suffix}"
}

puts ""
puts "#endif //#{namespace_suffix}"
puts ""
