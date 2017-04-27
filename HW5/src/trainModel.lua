require 'torch'
require 'xlua'
require("train")
require("Model");
require("BN")
require("Criterion");


local batchsize = 15
local lr = 0.0001
lambda = 0.1
local epochs = 50000

local t={usage="-modelName (model name) -data /path/to/train.bin -target labels", version=""}
local op = xlua.OptionParser(t)
op:option{"-modelName", action='store', dest='modelName'}
op:option{"-data", action='store', dest='data'}
op:option{"-target", action='store', dest='target'}

local options,args = op:parse()

-- TODO
options['modelName']= "A"
options['data']= "../data/tr_data.bin"
options['target']= "../data/tr_labels.bin"
--
-- load training images
tr_x = torch.load(options['data'])
-- load training labels 
tr_y = torch.load(options['target']):double() + 1

-- for i=1,tr_x:size(1) do
--     tr_x[i] = image.rgb2yuv(tr_x[i])
-- end

tr_x = torch.reshape(tr_x, tr_x:size(1), tr_x:size(2)*tr_x:size(3)*tr_x:size(4))

-- For cross validation
te_x = tr_x:sub(40001, 50000)
tr_x = tr_x:sub(1, 40000)
te_y = tr_y:sub(40001, 50000)
tr_y = tr_y:sub(1, 40000)

-- TODO
model = Model.new()
layer1 = Linear.new(3*32*32, 10, batchsize)
layer2 = BN.new(10,10, batchsize)
layer3 = ReLU.new()
model:addLayer(layer1)
model:addLayer(layer2)
model:addLayer(layer3)
criterion = Criterion.new()
-- 

model.x_mean = torch.mean(tr_x:double(), 1)
model.x_std = torch.std(tr_x:double(), 1)

tr_x = norm(tr_x, model.x_mean, model.x_std)
te_x = norm(te_x, model.x_mean, model.x_std)

bestmodel = Model.new()
bestmodel:clone(model)
bestmodel.x_mean = model.x_mean
bestmodel.x_std = model.x_std


os.execute("mkdir -p " .. options['modelName'])
torch.save(options['modelName'].."/model.bin", model)

model.isTrain = true
train(epochs, lr, lambda, batchsize)
model.isTrain = false

os.execute("mkdir -p bestModel_2")
torch.save("bestModel_2/model.bin", bestmodel)