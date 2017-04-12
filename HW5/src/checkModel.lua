require 'torch'
require 'xlua'

t={usage="Read problem statement for usage", version="9.0x"}
op = xlua.OptionParser(t)
op:option{"-x", action='store', dest='x', help="hel"}
options,args = op:parse()
--
-- now options is the table of options (key, val) and args is the table with non-option arguments.
-- You can use op.fail(message) for failing and op.help() for printing the usage as you like.
--

print(options)