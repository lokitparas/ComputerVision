
-- package.loaded["train_and_test_loop"] = nil; require("train_and_test_loop"); criterion = Criterion.new();

function get_xi(data_x, idx)  
    xi = (data_x[idx]:double() - x_mean)
    xi = xi:cdiv(x_std)
    xi = xi:reshape(3*32*32)
    return xi
end

function mod(a, b)
    return a - math.floor(a/b)*b
end

randomIdx = {}
for i = 1,100 do
    table.insert(randomIdx, math.random(10000))
end
function evaluate(model, data_x, data_y) 
    errors = 0
    for i = 1,#randomIdx do
        idx = randomIdx[i]
        xi = get_xi(data_x, idx)
        op = model:forward(xi)
        _, op_label = torch.max(op, 1)
        ti = data_y[idx]
        if ti ~= op_label[1] then
            errors = errors + 1
        end
    end
    return errors/#randomIdx
end

function train_and_test_loop(no_iterations, lr, lambda, batchsize)
    for i = 0, no_iterations do
        -- shuffle data
        if mod(i, tr_x:size(1)) == 0 then
            shuffle = torch.randperm(tr_x:size(1))
        end
        if mod(i, te_x:size(1)) == 0 then
            shuffle_te = torch.randperm(te_x:size(1))
        end

        -- learning rate multiplier
        if i == 60000 then lr = lr * 0.1 end

        -- trainin input and target
 

        --making batches
        x_batch = torch.zeros(tr_x:size(2), batchsize)
        t_batch = torch.zeros(batchsize)

        for j = 1, batchsize do
            -- print(j)
            idx = shuffle[mod(i+j, tr_x:size(1)) + 1] 
            -- print(idx)
            x_batch[{{}, j}] = get_xi(tr_x, idx) 
            t_batch[j] = tr_y[idx]
        end

        
        -- do forward of the model, compute loss
        -- and then do backward of the model

        op = model:forward(x_batch)
        loss_tr = criterion:forward(op:t(), t_batch)
        dl_do = criterion:backward(op:t(), t_batch)
        model:backward(x_batch, dl_do:t())
        epochloss_tr = epochloss_tr + loss_tr

        -- test input and target
        x_test_batch = torch.zeros(te_x:size(2), batchsize)
        t_test_batch = torch.zeros(batchsize)


        for j = 1, batchsize do
            idx = shuffle_te[mod(i+j, te_x:size(1)) + 1] 
            x_test_batch[{{}, j}] = get_xi(te_x, idx) 
            t_test_batch[j] = te_y[idx]
        end

        -- do forward of the model and compute loss
        op = model:forward(x_test_batch) 
        loss_te = criterion:forward(op:t(), t_test_batch)
        epochloss_te = epochloss_te + loss_te

        -- udapte model weights
        model:gradient_descent(lr)

        if mod(i, 1000) == 0 then
            if i ~= 0 then
                table.insert(epochlosses_te, epochloss_te/1000)
                table.insert(epochlosses_tr, epochloss_tr/1000)
            end
            epochloss_te = 0
            epochloss_tr = 0
            err = evaluate(model, tr_x, tr_y)
            print('iter: '..i.. ', accuracy: '..(1 - err)*100 ..'%')
            if (err < besterr) then
                besterr = err
                -- bestmodel:copy(model)
                print(' -- best accuracy achieved: '.. (1- besterr)*100 ..'%')
            end
            -- collectgarbage()
        end
        -- print(i)
    end
end