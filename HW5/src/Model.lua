require 'torch'

local Model = torch.class('Model')

function Model:__init( )
	self.Layers = {}
	self.isTrain = false
	self.numLayers = 0
	-- should be set to true when the model is training and false otherwise. 
	-- This is useful for modules where the forward passes differ between 
	--training and testing (e.g. Dropout, etc.).
end

function Model:forward(input)
	-- returns the output of the last Layer contained in model
	-- TODO Inputs should be always considered as batches. (num_input * batch_size)
	local linput = input
	for k=1, self.numLayers do
		linput = self.Layers[k]:forward(linput)
	end
	return linput
end

function Model:backward(input, gradOutput)
	-- sequentially calls the backward function for the Layers contained in the model 
	-- (to finally compute the gradient of the Loss with respect to the parameters of 
	-- the different Layers contained in the model) using the chain rule.
	local linput
	local lgradOutput = gradOutput
	for k=self.numLayers,2,-1 do
		linput = Layers[k-1].output 
		lgradOutput = Layers[k]:backward(linput, lgradOutput)
	end
	linput = input
	if self.numLayers > 0 then
		lgradOutput = Layers[1]:backward(linput, lgradOutput)
	end
end

function Model:dispGradParam()
	-- TODO sequentially print the parameters of the network with the Layer
	-- closer to output displayed first. The output format is a 2D matrix for each Layer
	-- with space separated elements.
	for k=self.numLayers,1,-1 do
		Layers[k]:dispGradParam()
	end
end

function Model:clearGradParam()
	-- makes the gradients of the parameters to 0 for every Layer
	for k=1, self.numLayers do
		Layers[k]:clearGradParam()
	end
end

function Model:addLayer(layer)
	self.numLayers = self.numLayers + 1
	self.Layers[self.numLayers] = layer
end
