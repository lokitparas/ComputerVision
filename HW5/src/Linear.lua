require 'torch'

local Linear = torch.class('Linear')

function Linear:__init(size_input, size_output, batch_size)
	-- appropriately initialize
	self.batch_size = batch_size
	self.output = torch.zeros(size_output, batch_size)
	self.W = (torch.rand(size_output, size_input):double()-0.5) * 0.001
	self.B = (torch.rand(size_output, 1):double()-0.5) * 0.001
	self.gradW = torch.zeros(size_output, size_input)
	self.gradB = torch.zeros(size_output, 1)
	self.gradInput = torch.zeros(size_input, batch_size)
end

function Linear:forward(input)
	-- computes and returns the output of the layer and also saves it in the state variable output
	-- input is size_input * batch_size
	if input:size():size() > 1 then
		rep_count = input:size(2)
	else
		rep_count = 1
	end
	self.output = self.B:repeatTensor(1, rep_count) + self.W * input
	return self.output

end

function Linear:backward(input, gradOutput)
	-- computes and updates the state variables gradInput, gradW and gradB and also returns gradInput
	
	-- self.gradW = gradOutput * input:t()
	-- self.gradB = gradOutput
	-- self.gradInput = self.W:t() *gradOutput  
	-- return self.gradInput

	self.gradW = (gradOutput * input:t()) / self.batch_size
	self.gradB = gradOutput:sum(2) / self.batch_size
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


function Linear:gradient_descent(lr)
	local momentum_alpha = 0.3
	if self.gradW_historical then 
		self.gradW_historical = (1-momentum_alpha)*self.gradW + momentum_alpha*self.gradW_historical
	else
		self.gradW_historical = self.gradW
	end

	if self.gradB_historical then 
		self.gradB_historical = (1-momentum_alpha)*self.gradB + momentum_alpha*self.gradB_historical
	else
		self.gradB_historical = self.gradB
	end


	self.W = self.W - lr * self.gradW_historical
    self.B = self.B - lr * self.gradB_historical
end
    