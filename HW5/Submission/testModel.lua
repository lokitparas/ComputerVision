require 'torch'
require 'xlua'
require("src/Model");

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

local t={usage="-modelName (model name) -data /path/to/test.bin -target labels", version=""}
local op = xlua.OptionParser(t)
op:option{"-modelName", action='store', dest='modelName'}
op:option{"-data", action='store', dest='data'}

local options,args = op:parse()

model = torch.load(options['modelName'].."/model.bin")
ts_x = torch.load('../data/te_data.bin')
ts_x = torch.reshape(ts_x, ts_x:size(1), ts_x:size(2)*ts_x:size(3)*ts_x:size(4))

ts_x = norm(ts_x, model.x_mean, model.x_std)

local fp = io.open(options['modelName'].."/submission.csv", "w")
fp:write("id,label\n")

ts_y = torch.zeros(ts_x:size(1))
for i=1,ts_x:size(1) do
	op = model:forward(ts_x[i])
    _, op_label = torch.max(op, 1)
	ts_y[i] = op_label[1][1]
	fp:write(string.format("%d,%d\n", i, ts_y[i]))
end
fp:close()

torch.save("testPrediction.bin", ts_y)
