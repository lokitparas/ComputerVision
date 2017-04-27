require 'torch'
require 'image'

local besterr = 1e10

function norm(data_x, mean, std)
	new_data_x=torch.zeros(data_x:size(1), data_x:size(2))
	for i=1,data_x:size(1) do
		xi = (data_x[i]:double() - mean)
    	xi = xi:cdiv(std)
    	xi = xi:reshape(3*32*32)
		new_data_x[i] = xi
	end
    return new_data_x
end

function mod(a, b)
    return a - math.floor(a/b)*b
end

randomIdx = {}
for i = 1,200 do
    table.insert(randomIdx, math.random(10000))
end

function evaluate(model, data_x, data_y) 
    errors = 0
    for i = 1,#randomIdx do
        xi = data_x[randomIdx[i]]
        op = model:forward(xi)
        _, op_label = torch.max(op, 1)
        ti = data_y[randomIdx[i]]
        if ti ~= op_label[1][1] then
            errors = errors + 1
        end
    end
    return errors/#randomIdx
end

function train(epochs, lr, lambda, batchsize)
	for i = 0, epochs do
        model.isTrain = true
        -- shuffle data
        if mod(i, tr_x:size(1)) == 0 then
            shuffle = torch.randperm(tr_x:size(1))
        end
        if mod(i, te_x:size(1)) == 0 then
            shuffle_te = torch.randperm(te_x:size(1))
        end

        -- learning rate multiplier
        if i == 60000 then lr = lr * 0.1 end

        -- training input and target

        --making batches
        x_batch = torch.zeros(tr_x:size(2), batchsize)
        t_batch = torch.zeros(batchsize)

        for j = 1, batchsize do
            idx = shuffle[mod(i+j, tr_x:size(1)) + 1] 
            x_batch[{{}, j}] = tr_x[idx]
            t_batch[j] = tr_y[idx]
        end

        
        -- do forward of the model, compute loss
        -- and then do backward of the model

        op = model:forward(x_batch)
        loss_tr = criterion:forward(op:t(), t_batch)
        dl_do = criterion:backward(op:t(), t_batch)
        model:backward(x_batch, dl_do:t())

        -- udapte model weights
        model:gradient_descent(lr)
        model:clearGradParam()
        model.isTrain = false

        if mod(i, 100) == 0 then
            err = evaluate(model, te_x, te_y)
            print('iter: '..i.. ', accuracy: '..(1 - err)*100 ..'%')
            if (err < besterr) then
                besterr = err
                bestmodel:copy(model)
                print(' -- best accuracy achieved: '.. (1- besterr)*100 ..'%')
            end
            collectgarbage()
        end
    end
end