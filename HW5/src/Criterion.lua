require 'torch'

local Criterion = torch.class('Criterion')

function Criterion:forward(input, target)
	-- which takes an input of size (batchsize) × (number of
	-- classes) and target which a 1D tensor of size (batchsize). This function computes
	-- the average cross-entropy loss over the batch.
	local loss = 0.0
	local soft = torch.exp(input)
	local norm = torch.sum(soft, 2)
	local batchsize = input:size(1)
	local llog = 0.0
	for i=1,batchsize do
		llog = -torch.log(soft[i][target[i]] / norm[i][1])
		loss = loss + llog
	end
	loss = loss / batchsize
	return loss
end

function Criterion:backward(input, target)
	-- computes and returns the gradient of the Loss with respect to the input to this layer.
	grad = torch.zeros(input:size())
	for i=1,batchsize do
		local soft = torch.exp(input[i])
		local norm = torch.sum(soft)
		soft = soft / norm
		grad[i] = soft
		grad[i][target[i]] = grad[i][target[i]] - 1
	end
	return grad
end