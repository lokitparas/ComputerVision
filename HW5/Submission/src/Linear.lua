require 'torch'

local Linear = torch.class('Linear')

function Linear:__init(size_input, size_output, batch_size)
	-- appropriately initialize
	self.batch_size = batch_size
	self.size_input = size_input
	self.size_output = size_output
	self.output = torch.zeros(size_output, batch_size)
	self.W = (torch.rand(size_output, size_input):double()-0.5) * 0.05
	self.B = (torch.rand(size_output):double()-0.5) * 0.05
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
	self.output = self.B:reshape(self.size_output, 1):repeatTensor(1, rep_count) + self.W * input
	return self.output

end

function Linear:backward(input, gradOutput)
	-- computes and updates the state variables gradInput, gradW and gradB and also returns gradInput
	
	-- self.gradW = gradOutput * input:t()
	-- self.gradB = gradOutput
	-- self.gradInput = self.W:t() *gradOutput  
	-- return self.gradInput

	if input:size():size() > 1 then
		rep_count = input:size(2)
	else
		rep_count = 1
	end

	self.gradW = (gradOutput * input:t()) / rep_count
	self.gradB = gradOutput:sum(2) /rep_count
	self.gradInput = self.W:t() * gradOutput
	return self.gradInput

end

function Linear:clearGradParam()
	self.gradW:zero()
	self.gradB:zero()
	self.gradInput:zero()
end

function Linear:dispGradParam()
	print("Linear")
	print("W ")
	print(self.W)
	print("B ")
	print(self.B)
end

function Linear:copy(model)
	self.W:copy(model.W)
	self.B:copy(model.B)
end

function Linear:gradient_descent(lr)
    self.W = self.W - lr * self.gradW
    self.B = self.B - lr * self.gradB
end

function Linear:class()
	return "Linear"
end
    

-- function Linear:gradient_descent(lr)
--  -- adagrad
-- 	if not self.GW then self.GW = torch.Tensor(self.size_output, self.size_input):fill(1e-8) end
-- 	if not self.GB then self.GB = torch.Tensor(self.size_output):fill(1e-8) end
-- 	self.GW = self.GW + self.gradW
-- 	self.GB = self.GB + self.gradB
	
-- 	local Wupdate = torch.pow(self.GW,-0.5)
-- 	Wupdate:cmul(self.gradW)
-- 	local Bupdate = torch.pow(self.GB, -0.5)
-- 	Bupdate:cmul(self.GB)
-- 	self.W = self.W - lr * Wupdate
--     self.B = self.B - lr * Bupdate
-- end

-- function Linear:gradient_descent(lr)
-- -- with momentum
-- 	local momentum_alpha = 0.0
-- 	if self.gradW_historical then 
-- 		self.gradW_historical = (1-momentum_alpha)*self.gradW + momentum_alpha*self.gradW_historical
-- 	else
-- 		self.gradW_historical = self.gradW:clone()
-- 	end

-- 	if self.gradB_historical then 
-- 		self.gradB_historical = (1-momentum_alpha)*self.gradB + momentum_alpha*self.gradB_historical
-- 	else
-- 		self.gradB_historical = self.gradB:clone()
-- 	end
-- 	self.W = self.W - lr * self.gradW_historical
--     self.B = self.B - lr * self.gradB_historical
-- end
