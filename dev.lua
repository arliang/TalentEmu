﻿--[[--
	by ALA @ 163UI
--]]--
----------------------------------------------------------------------------------------------------
local __addon, __private = ...;
local MT = __private.MT;
local CT = __private.CT;
local VT = __private.VT;
local DT = __private.DT;

--		upvalue
-->
	local L = CT.L;

-->		constant
-->
MT.BuildEnv('DEV');
-->		predef
-->		DEV
	--

	MT.RegisterOnInit('DEV', function(LoggedIn)
	end);
	MT.RegisterOnLogin('DEV', function(LoggedIn)
	end);

-->
