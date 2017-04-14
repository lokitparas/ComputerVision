-- require 'Linear'
require("Linear");
require("ReLU");
require("Model");
require("Criterion");
require("train_and_test_loop");

tr_x = torch.load('../data/tr_data.bin')
-- load trainin labels 
tr_y = torch.load('../data/tr_labels.bin'):double() + 1
-- load test images
ts_x = torch.load('../data/te_data.bin')
-- load test labels 
-- ts_y = torch.load('./te_labels.bin'):double() + 1

tr_x = torch.reshape(tr_x, tr_x:size(1), tr_x:size(2)*tr_x:size(3)*tr_x:size(4))
ts_x = torch.reshape(ts_x, ts_x:size(1), ts_x:size(2)*ts_x:size(3)*ts_x:size(4))

-- For cross validation
te_x = tr_x:sub(40001, 50000)
tr_x = tr_x:sub(1, 40000)
te_y = tr_y:sub(40001, 50000)
tr_y = tr_y:sub(1, 40000)



besterr = 1e10

-- compute mean
x_mean = torch.mean(tr_x:double(), 1)
x_std = torch.std(tr_x:double(), 1)

-- for plotting losses later on
epochloss_te = 0
epochloss_tr = 0
epochlosses_tr = {}
epochlosses_te = {}

batchsize = 20

-- define the model and criterion
model = Model.new()
layer1 = Linear.new(3*32*32, 10, batchsize)
layer2 = ReLU.new()
layer3 = Linear.new(3*32*32, 10, batchsize)
layer4 = ReLU.new()
model:addLayer(layer1)
model:addLayer(layer2)
model:addLayer(layer3)
model:addLayer(layer4)
criterion = Criterion.new()
bestmodel = Model.new()
bestmodel:clone(model)

-- run it
lr = 0.00001
lambda = 0.0
-- batchsize = 100
train_and_test_loop(20000, lr, lambda, batchsize)

-- ts_y = bestmodel:predict(ts_x)
-- ts_y = ts_y -1
local fp = io.open("submission.csv", "w")
fp:write("id,label\n")

for i=1,ts_x:size(1) do
	op = model:forward(get_xi(ts_x, i))
    _, op_label = torch.max(op, 1)
	fp:write(string.format("%d,%d\n", i, op_label[1][1]))
end
fp:close()