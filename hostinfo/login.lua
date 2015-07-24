--[[
Copyright 2014 Rackspace

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

local table = require('table')
local los = require('los')
local readCast = require('./misc').readCast

--[[ Login ]]--
local Info = HostInfo:extend()
function Info:initialize()
  HostInfo.initialize(self)
end

function Info:run(callback)

  if los.type() ~= 'linux' then
    self._error = 'Unsupported OS for Login Definitions'
    return callback()
  end

  local filename = "/etc/login.defs"
  local outTable = {}
  local errTable = {}

  local function casterFunc(iter, obj)
    local key = iter()
    local val = iter()
    obj[key] = val
  end

  local function cb()
    if outTable == nil then
      self._error = errTable
    else
      table.insert(self._params, {
        ['login_defs'] = outTable[1]
      })
    end
    return callback()
  end

  readCast(filename, errTable, outTable, casterFunc, cb)
end

function Info:getType()
  return 'LOGIN'
end

return Info
