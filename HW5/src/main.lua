tr_x = torch.load('./tr_data.bin')
-- load trainin labels 
tr_y = torch.load('./tr_labels.bin'):double() + 1
-- load test images
te_x = torch.load('./te_data.bin')
-- load test labels 
-- te_y = torch.load('./te_labels.bin'):double() + 1

besterr = 1e10

-- for plotting losses later on
epochloss_te = 0
epochloss_tr = 0
epochlosses_tr = {}
epochlosses_te = {}

-- define the model and criterion
model = Linear.new(0.001)
criterion = CEC.new()
bestmodel = Linear.new(0)

-- run it
lr = 0.00001
lambda = 0.0
batchsize = 100
train_and_test_loop(100000, lr, lambda, batchsize)