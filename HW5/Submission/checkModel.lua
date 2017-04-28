-- th checkModel.lua -config ../sample/modelConfig_2.txt -i ../sample/input_sample_2.bin -ig ../sample/gradOutput_sample_2.bin -o ../sample_output/output_sample_2.bin -ow gradW_sample_2.bin -ob gradB_sample_2.bin -og gradInput_sample_2.bin
require 'torch'
require 'xlua'
require("src/Linear");
require("src/ReLU");
require("src/Model");


function layerFromString(line, batchsize)
	if line == "relu" then
		return ReLU.new()
	else
		local sz_in, sz_out = line:match("%w+ (%d+) (%d+)")
		return Linear.new(sz_in, sz_out, batchsize)
	end
end


local t={usage="Read problem statement for usage", version=""}
local op = xlua.OptionParser(t)
op:option{"-config", action='store', dest='config'}
op:option{"-i", action='store', dest='i'}
op:option{"-ig", action='store', dest='ig'}
op:option{"-o", action='store', dest='o'}
op:option{"-ow", action='store', dest='ow'}
op:option{"-ob", action='store', dest='ob'}
op:option{"-og", action='store', dest='og'}

local options,args = op:parse()


local input = torch.load(options['i'])
input = torch.reshape(input, input:size(1), input:size(2)*input:size(3)*input:size(4)):t()
local batchsize = input:size(2)
local gradOutput = torch.load(options['ig']):t()

model  = Model.new()
local f = io.open(options['config'], 'rb')
local num_layers = f:read "*n"
local line = f:read "*line" -- To remove newline

line = f:read "*line"
while line and ((string.sub(line, 1, 6) == "linear") or (string.sub(line, 1, 4) == "relu")) do
	model:addLayer(layerFromString(line, batchsize))
	line = f:read "*line"
end

-- Loading weights
local W = torch.load(line)

-- Loading biases
line = f:read "*line"
local B = torch.load(line)
local i = 1
for k=1, model.numLayers do
	if model.Layers[k]:class() == 'Linear' then
		model.Layers[k].W = W[i]
		model.Layers[k].B = B[i]
	
		i = i+1
	end
end


-- No normalization

local op = model:forward(input)
gradInput = model:backward(input, gradOutput)

torch.save(options['o'], op:t())

ow = {}
for i=1,model.numLayers do
	if model.Layers[i]:class() == 'Linear' then
		table.insert(ow, model.Layers[i].gradW)
	end
end
torch.save(options['ow'], ow)

ob = {}
for i=1,model.numLayers do
	if model.Layers[i]:class() == 'Linear' then
		table.insert(ob, model.Layers[i].gradB)
	end
end
torch.save(options['ob'], ob)

torch.save(options['og'], gradInput)

-- The file modelConfig.txt has the following format:
-- (No. layers)
-- (Layer description)
-- (Layer description)
-- .
-- (Layer weights path) 
-- (Layer bias path)
--
-- (Layer description) varies for the two mandatory layers as: 
-- • Linear Layer: ‘linear’ (i/p nodes) (o/p nodes)
-- • ReLU layer: ‘relu’
-- The (Layer weights path) is a path to a Lua table saved as a ‘.bin’ file. The table has as many entries as there are Linear layers in the network and each entry contains the 2D weight tensor of that layer. The (layer bias path) line has similar information for bias.
-- An example of ‘modelConfig.txt’ is included in the assignment folder. The arguments (a),(b) and (c) are inputs to the script.
-- The ‘input.bin’ is a 4D torch tensor. The ‘gradOutput.bin’ contains gradients with respect to the output of the model. These are randomly chosen values to test the implementation and not actually calculated against a loss. For this evaluation, the batch-size is to be taken as the number of data points provided in the sample ‘input.bin’.
-- The arguments (d),(e),(f) and (g) are to be saved by the script. The ‘gradWeight.bin’ and ’gradB.bin’ are lua tables having same format as the tables containing sample W and B. The ‘output.bin’ is the tensor containing output of the model. Each entry should have its corresponding gradW and gradB tensor. The ‘gradInput.bin’ is gradient of the Loss with respect to the ‘input.data’ to the model. ‘torch.save’ should be used to save the bin files. (Remember to reset the gradient values to zero before you back propagate).
