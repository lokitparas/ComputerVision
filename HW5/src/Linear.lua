require 'torch'

local Linear = torch.class('Linear')

function Linear:init(num_input, num_output)
	-- appropriately initialize
	self.output = torch.zeros(num_output, 1)
	self.W = torch.rand(num_output, num_input)
	self.B = torch.rand(num_output, 1)
	self.gradW = torch.zeros(num_output, num_input)
	self.gradB = torch.zeros(num_output, 1)
	self.gradInput = torch.zeros(num_input, 1)
end

function Linear:forward(input)
	-- computes and returns the output of the layer and also saves it in the state variable output
	self.output = self.B + self.W * input
	return self.output

end

function Linear:backward(input, gradOutput)
	-- computes and updates the state variables gradInput, gradW and gradB and also returns gradInput
	self.gradW = gradOutput * input:t()
	self.gradB = gradOutput
	self.gradInput = self.W:t() *gradOutput  
	return self.gradInput
end

function Linear:clearGradParam()
	self.gradW:zero()
	self.gradB:zero()
	self.gradInput:zero()
end

function Linear:dispGradParam()
	-- TODO
end