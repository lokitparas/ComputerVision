require 'torch'

local Linear = torch.class('Linear')

function Linear:__init(size_input, size_output, batch_size)
	-- appropriately initialize
	self.batch_size = batch_size
	self.output = torch.zeros(size_output, batch_size)
	self.W = torch.rand(size_output, size_input)
	self.B = torch.rand(size_output, 1)
	self.gradW = torch.zeros(size_output, size_input)
	self.gradB = torch.zeros(size_output, 1)
	self.gradInput = torch.zeros(size_input, batch_size)
end

function Linear:forward(input)
	-- computes and returns the output of the layer and also saves it in the state variable output
	-- input is size_input * batch_size
	self.output = self.B::repeatTensor(self.batch_size) + self.W * input
	return self.output

end

function Linear:backward(input, gradOutput)
	-- computes and updates the state variables gradInput, gradW and gradB and also returns gradInput
	
	-- self.gradW = gradOutput * input:t()
	-- self.gradB = gradOutput
	-- self.gradInput = self.W:t() *gradOutput  
	-- return self.gradInput

	self.gradW = (gradOutput * input:t()) / batch_size
	self.gradB = gradOutput:sum(2) / batch_size
	self.gradInput = self.W:t() * gradOutput
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