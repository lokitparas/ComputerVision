require 'torch'

local ReLU = torch.class('ReLU')

function ReLU:__init()
	-- may be empty
end

function ReLU:forward(input)
	-- computes the output of the layer and also updates the state variable output
	-- max(0,x)
	-- input of size size_input * batch_size
	self.output = input:clone()
	self.output[torch.lt(self.output,0.0)] = 0.0
	return self.output
end

function ReLU:backward(input, gradOutput)
	-- computes and returns the gradient of the Loss with respect to the input 
	-- to this layer, updates the corresponding state variable gradInput and also returns it
	-- x>0 : 1 else 0
	-- input of size size_input * batch_size

	local lgradInput = input:clone()
	lgradInput[torch.gt(lgradInput, 0.0)] = 1.0
	lgradInput[torch.lt(lgradInput, 0.0)] = 0.0

	lgradInput:cmul(gradOutput)
	if self.gradInput then 
		self.gradInput = self.gradInput + lgradInput
	else
		self.gradInput = lgradInput:clone()
	end
	return lgradInput
end

function ReLU:clearGradParam()
  self.gradInput:zero()
end

function ReLU:dispGradParam()
	print("ReLU")
end

function ReLU:copy(model)
end

function ReLU:gradient_descent(lr)
end

function ReLU:class()
	return "ReLU"
end