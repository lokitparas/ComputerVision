require 'torch'
require 'xlua'
require("src/Criterion")


local t={usage="Read problem statement for usage", version=""}
local op = xlua.OptionParser(t)
op:option{"-config", action='store', dest='config'}
op:option{"-i", action='store', dest='i'}
op:option{"-t", action='store', dest='t'}
op:option{"-og", action='store', dest='og'}

local options,args = op:parse()


local input = torch.load(options['i'])
local target = torch.load(options['t'])

-- print(input)
-- print(target)

print(Criterion:forward(input, target, 0))
torch.save(options['og'], Criterion:backward(input, target))