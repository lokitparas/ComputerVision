-- require 'Linear'
require("Linear");
require("Model");
require("Criterion");
require("train_and_test_loop");

tr_x = torch.load('../data/tr_data.bin')
-- load trainin labels 
tr_y = torch.load('../data/tr_labels.bin'):double() + 1
-- load test images
te_x = torch.load('../data/te_data.bin')
-- load test labels 
-- te_y = torch.load('./te_labels.bin'):double() + 1

tr_x = torch.reshape(tr_x, tr_x:size(1), tr_x:size(2)*tr_x:size(3)*tr_x:size(4))
te_x = torch.reshape(te_x, te_x:size(1), te_x:size(2)*te_x:size(3)*te_x:size(4))

besterr = 1e10

-- compute mean
x_mean = torch.mean(tr_x:double(), 1)
x_std = torch.std(tr_x:double(), 1)

-- for plotting losses later on
epochloss_te = 0
epochloss_tr = 0
epochlosses_tr = {}
epochlosses_te = {}

batchsize = 2

-- define the model and criterion
layer1 = Linear.new(3*32*32, 10, batchsize)
model = Model.new()
model:addLayer(layer1)
criterion = Criterion.new()
-- bestmodel = Linear.new(0)

-- run it
lr = 0.00001
lambda = 0.0
-- batchsize = 100
train_and_test_loop(10, lr, lambda, batchsize)