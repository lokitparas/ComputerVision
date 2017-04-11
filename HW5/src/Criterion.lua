require 'torch'

local Criterion = totch.class('Criterion')

function Criterion:forward(input, target)
	-- which takes an input of size (batchsize) × (number of
	-- classes) and target which a 1D tensor of size (batchsize). This function computes
	-- the average cross-entropy loss over the batch.
end

function Criterion:backward(input, target)
	-- computes and returns the gradient of the Loss with respect to the input to this layer.
end