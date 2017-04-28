require 'torch'
require("./Linear");
require("./ReLU");
require("./BN")

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
	-- Inputs should be always considered as batches. (num_input * batch_size)
	isTrain = self.isTrain
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
		linput = self.Layers[k-1].output 
		lgradOutput = self.Layers[k]:backward(linput, lgradOutput)
	end
	linput = input
	if self.numLayers > 0 then
		lgradOutput = self.Layers[1]:backward(linput, lgradOutput)
	end
	return lgradOutput
end

function Model:dispGradParam()
	-- TODO sequentially print the parameters of the network with the Layer
	-- closer to output displayed first. The output format is a 2D matrix for each Layer
	-- with space separated elements.
	for k=self.numLayers,1,-1 do
		print("Layer "..k)
		self.Layers[k]:dispGradParam()
	end
end

function Model:copy(model)
	for k=1, self.numLayers do
		self.Layers[k]:copy(model.Layers[k])
	end
end

function Model:clone(model)
	self.numLayers = model.numLayers
	self.isTrain = model.isTrain
	for k=1, self.numLayers do
		if model.Layers[k]:class() == "Linear" then
			self.Layers[k] = Linear.new(model.Layers[k].size_input, 
				model.Layers[k].size_output, model.Layers[k].batch_size)
			self.Layers[k]:copy(model.Layers[k])
		elseif model.Layers[k]:class() == "ReLU" then
			self.Layers[k] = ReLU.new()
		elseif model.Layers[k]:class() == "BN" then
			self.Layers[k] = BN.new()
			self.Layers[k]:copy(model.Layers[k])
		end
	end
end

function Model:clearGradParam()
	-- makes the gradients of the parameters to 0 for every Layer
	for k=1, self.numLayers do
		self.Layers[k]:clearGradParam()
	end
end

function Model:addLayer(layer)
	self.numLayers = self.numLayers + 1
	self.Layers[self.numLayers] = layer
end

function Model:gradient_descent(lr)
	for k=self.numLayers,1,-1 do
		self.Layers[k]:gradient_descent(lr)
	end
end
