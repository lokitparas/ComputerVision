function get_xi(data_x, idx)  
    xi = (data_x[idx]:double() - x_mean)
    xi = xi:cdiv(x_std)
    xi = xi:reshape(3*32*32)
    return xi
end

function mod(a, b)
    return a - math.floor(a/b)*b
end

function gradient_descent(model, lr)
    model.W = model.W + lr * model.gradW
    model.b = model.b + lr * model.gradb
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
        loss_tr = Criterion:forward(op:t(), t_batch)
        dl_do = Criterion:backward(op:t(), t_batch)
        model:backward(x_batch, dl_do)
        epochloss_tr = epochloss_tr + loss_tr

        -- test input and target
        x_test_batch = torch.zeros(batchsize, te_x:size(2))
        t_test_batch = torch.zeros(batchsize, te_y:size(1))


        for j = 0, batchsize do
            idx = shuffle_te[mod(i+j, te_x:size(1)) + 1] 
            x_test_batch[j] = get_xi(te_x, idx) 
            t_test_batch[j] = te_y[idx]
        end

        -- do forward of the model and compute loss
        op = model:forward(x_test_batch) 
        loss_te = criterion:forward(op, t_test_batch, model, lambda)
        epochloss_te = epochloss_te + loss_te

        -- udapte model weights
        gradient_descent(model, lr)

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
                bestmodel:copy(model)
                print(' -- best accuracy achieved: '.. (1- besterr)*100 ..'%')
            end
            collectgarbage()
        end
    end
end