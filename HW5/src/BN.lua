require 'torch'

local BN = torch.class('BN')

function BN:__init(size_input, size_output, batch_size)
	-- appropriately initialize
	self.beta = 0
	self.gamma = 1
	self.output = torch.zeros(size_output, batch_size)
end

function BN:forward(input)
	-- computes and returns the output of the layer and also saves it in the state variable output
	-- input is size_input * batch_size
	if isTrain then
		local mean_batch = input:mean(2) 
		local var_batch = input:var(2) + 1e-8
		var_batch = torch.sqrt(var_batch)

		if input:size():size() > 1 then
			rep_count = input:size(2)
		else
			rep_count = 1
		end
		norm_input = (input - mean_batch:repeatTensor(1, rep_count)):cdiv(var_batch:repeatTensor(1, rep_count))
		return self.output  --  todo : use gamma and beta
	else
		return input
	end

end

function BN:backward(input, gradOutput)
	-- computes and updates the state variables gradInput, gradW and gradB and also returns gradInput
	
	-- self.gradW = gradOutput * input:t()
	-- self.gradB = gradOutput
	-- self.gradInput = self.W:t() *gradOutput  
	-- return self.gradInput	
	self.gradBeta = gradOutput:sum(1)
	self.gradGamma = (gradOutput * self.norm_input):sum(1)
	
	local gradNormInput = self.gamma * gradOutput
	local mean_batch = input:mean(2) 
	local var_batch = input:var(2) + 1e-8
	var_batch = 1/var_batch
	local N = input:size(1)
	var_batch = torch.sqrt(var_batch)

	if input:size():size() > 1 then
		rep_count = input:size(2)
	else
		rep_count = 1
	end
	local norm_input = (input - mean_batch:repeatTensor(1, rep_count)):cdiv(var_batch:repeatTensor(1, rep_count))


	local answer = (1/N)*(var_batch:repeatTensor(1,rep_count))
	answer = answer*(N*gradNormInput - gradNormInput:sum(1) - norm_input*(gradNormInput* norm_input):sum(1))
	return answer
end

function BN:dispGradParam()
	-- TODO
end


function BN:class()
	return "BN"
end
    