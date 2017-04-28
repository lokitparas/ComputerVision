require 'torch'

local BN = torch.class('BN')

function BN:__init()
	-- appropriately initialize
	self.beta = 0
	self.gamma = 1
	self.gradGamma = 0
	self.gradBeta = 0
end

function BN:forward(input)
	-- computes and returns the output of the layer and also saves it in the state variable output
	-- input is size_input * batch_size
	if isTrain then
		self.mean_batch = input:mean(2) 
		self.var_batch = input:var(2) + 1e-8
		var_batch = torch.sqrt(self.var_batch)

		if input:size():size() > 1 then
			rep_count = input:size(2)
		else
			rep_count = 1
		end
		norm_input = (input - self.mean_batch:repeatTensor(1, rep_count)):cdiv(self.var_batch:repeatTensor(1, rep_count))

		self.output = self.gamma*norm_input - self.beta

		-- print(input)
		-- print(self.output)
		-- print(self.gamma)
		-- print(self.beta)
		return self.output
	else
		-- return input
		norm_input = (input - self.mean_batch:repeatTensor(1, rep_count)):cdiv(self.var_batch:repeatTensor(1, rep_count))
		return self.gamma*norm_input - self.beta
	end

end

function BN:backward(input, gradOutput)
	-- computes and updates the state variables gradInput, gradW and gradB and also returns gradInput
	
	-- self.gradW = gradOutput * input:t()
	-- self.gradB = gradOutput
	-- self.gradInput = self.W:t() *gradOutput  
	-- return self.gradInpuT
	
	local gradNormInput = self.gamma * gradOutput
	local mean_batch = input:mean(2) 
	local var_batch = input:var(2) + 1e-8
	var_batch = torch.pow(var_batch,-1)
	local N = input:size(1)
	var_batch = torch.sqrt(var_batch)

	if input:size():size() > 1 then
		rep_count = input:size(2)
	else
		rep_count = 1
	end
	local norm_input = (input - mean_batch:repeatTensor(1, rep_count)):cdiv(var_batch:repeatTensor(1, rep_count))

	self.gradBeta = gradOutput:sum(1):sum(2)
	self.gradGamma = (norm_input:cmul(gradOutput)):sum(1):sum(2)
	-- print(self.gradGamma)
	-- print(self.gradBeta)
	-- print(gradOutput)


	local answer = (1/N)*(var_batch:repeatTensor(1,rep_count))
	answer = answer:cmul(N*(gradNormInput) - (gradNormInput:sum(1)):repeatTensor(N,1) - norm_input:cmul(gradNormInput:cmul(norm_input:sum(1):repeatTensor(N,1))) )
	return answer
end

function BN:dispGradParam()
	print("Batch Normalize")
	print("gamma ".. gamma)
	print("beta "..beta)
end

function BN:gradient_descent(lr)
	self.gamma = self.gamma - lr * self.gradGamma
	self.gamma = self.gamma[1][1]
    self.beta = self.beta - lr * self.gradBeta
    self.beta = self.beta[1][1]
end

function BN:clearGradParam()
	self.gradGamma:zero()
	self.gradBeta:zero()
	
end


function BN:copy(model)
	self.gamma = model.gamma
	self.beta = model.beta
end


function BN:class()
	return "BN"
end
    