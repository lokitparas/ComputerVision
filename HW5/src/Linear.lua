require 'torch'

local Linear = torch.class('Linear')

function Linear:__init(size_input, size_output)
	-- appropriately initialize
	self.output = torch.zeros(size_output, 1)
	self.W = torch.rand(size_output, size_input)
	self.B = torch.rand(size_output, 1)
	self.gradW = torch.zeros(size_output, size_input)
	self.gradB = torch.zeros(size_output, 1)
	self.gradInput = torch.zeros(size_input, 1)
end

function Linear:forward(input)
	-- computes and returns the output of the layer and also saves it in the state variable output
	self.output = self.B + self.W * input
	return self.output

end

function Linear:backward(input, gradOutput)
	-- computes and updates the state variables gradInput, gradW and gradB and also returns gradInput
	
	-- self.gradW = gradOutput * input:t()
	-- self.gradB = gradOutput
	-- self.gradInput = self.W:t() *gradOutput  
	-- return self.gradInput

	self.gradW = self.gradW + gradOutput * input:t()
	self.gradB = self.gradB + gradOutput
	self.gradInput = self.gradInput + self.W:t() *gradOutput  
	return self.W:t() *gradOutput  

end

function Linear:clearGradParam()
	self.gradW:zero()
	self.gradB:zero()
	self.gradInput:zero()
end

function Linear:dispGradParam()
	-- TODO
end