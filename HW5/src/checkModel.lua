require 'torch'
require 'xlua'

local t={usage="Read problem statement for usage", version="9.0x"}
local op = xlua.OptionParser(t)
op:option{"-config", action='store', dest='config'}
op:option{"-i", action='store', dest='i'}
op:option{"-ig", action='store', dest='ig'}
op:option{"-o", action='store', dest='o'}
op:option{"-ow", action='store', dest='ow'}
op:option{"-ob", action='store', dest='ob'}
op:option{"-og", action='store', dest='og'}

local options,args = op:parse()
--
-- now options is the table of options (key, val) and args is the table with non-option arguments.
-- You can use op.fail(message) for failing and op.help() for printing the usage as you like.
--

print(options)

local f = io.open(options['config'], 'rb')
lines = f:read "*a"

local i = 1
local line = lines[i].split()

while 

-- The file modelConfig.txt has the following format:
-- (No. layers)
-- (Layer description)
-- (Layer description)
-- .
-- (Layer weights path) 
-- (Layer bias path)
-- (Layer description) varies for the two mandatory layers as: 
-- • Linear Layer: ‘linear’ (i/p nodes) (o/p nodes)
-- • ReLU layer: ‘relu’
-- The (Layer weights path) is a path to a Lua table saved as a ‘.bin’ file. The table has as many entries as there are Linear layers in the network and each entry contains the 2D weight tensor of that layer. The (layer bias path) line has similar information for bias.
-- An example of ‘modelConfig.txt’ is included in the assignment folder. The arguments (a),(b) and (c) are inputs to the script.
-- The ‘input.bin’ is a 4D torch tensor. The ‘gradOutput.bin’ contains gradients with respect to the output of the model. These are randomly chosen values to test the implementation and not actually calculated against a loss. For this evaluation, the batch-size is to be taken as the number of data points provided in the sample ‘input.bin’.
-- The arguments (d),(e),(f) and (g) are to be saved by the script. The ‘gradWeight.bin’ and ’gradB.bin’ are lua tables having same format as the tables containing sample W and B. The ‘output.bin’ is the tensor containing output of the model. Each entry should have its corresponding gradW and gradB tensor. The ‘gradInput.bin’ is gradient of the Loss with respect to the ‘input.data’ to the model. ‘torch.save’ should be used to save the bin files. (Remember to reset the gradient values to zero before you back propagate).