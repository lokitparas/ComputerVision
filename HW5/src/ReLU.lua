require 'torch'

local ReLU = totch.class('ReLU')

function ReLU:init( )
	-- may be empty
end

function ReLU:forward(input)
	-- computes the output of the layer and also updates the state variable output
	-- max(0,x)
	self.output = input
	self.output[torch.lt(self.output,0.0)] = 0.0
	return self.output
end

function ReLU:backward(input, gradOutput)
	-- computes and returns the gradient of the Loss with respect to the input 
	-- to this layer, updates the corresponding state variable gradInput and also returns it
	-- x>0 : 1 else 0
	self.gradInput = input
	self.gradInput[torch.gt(self.gradInput, 0.0)] = 1.0
	self.gradInput[torch.lt(self.gradInput, 0.0)] = 0.0

	-- Loss = 0 if x>0 else -x
	local loss = -input
	loss[torch.lt(x, 0.0)] = 0.0
	return loss, self.gradInput
end

function ReLU:clearGradParam()
  self.gradInput:zero()
end

function ReLU:dispGradParam()
	-- TODO
end