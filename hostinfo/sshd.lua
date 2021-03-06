--[[
Copyright 2015 Rackspace

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS-IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
--]]

local HostInfo = require('./base').HostInfo
local run = require('./misc').run
local Transform = require('stream').Transform

--------------------------------------------------------------------------------------------------------------------
local Reader = Transform:extend()
function Reader:initialize()
  Transform.initialize(self, {objectMode = true})
end

function Reader:_transform(line, cb)
  line = line:gsub("^%s*(.-)%s*$", "%1")
  local _, _, key, value = line:find("(.*)%s(.*)")
  if key then self:push({[key] = value}) end
  cb()
end
--------------------------------------------------------------------------------------------------------------------

local Info = HostInfo:extend()

function Info:_run(callback)
  local outTable, errTable = {}, {}
  local cmd, args = 'sshd', {'-T'}

  local function finalCb()
    self:_pushParams(errTable, outTable)
    return callback()
end

  local child = run(cmd, args)
  local reader = Reader:new()
  child:pipe(reader)
  reader:on('data', function(data)
    for k, v in pairs(data) do
      outTable[k] = v
    end
  end)
  reader:on('error', function(data) table.insert(errTable, data) end)
  reader:once('end', finalCb)
end

function Info:getPlatforms()
  return {'linux', 'darwin'}
end

function Info:getType()
  return 'SSHD'
end

exports.Info = Info
exports.Reader = Reader
