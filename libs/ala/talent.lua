--[[--
	ALA@163UI
--]]--

local __version = 220824.0;

local _G = _G;
_G.__ala_meta__ = _G.__ala_meta__ or {  };
local __ala_meta__ = _G.__ala_meta__;

if __ala_meta__.BUILD == "RETAIL" then
	return;
end

-->			versioncheck
	local __emulib = __ala_meta__.__emulib;
	if __emulib ~= nil and __emulib.__minor >= __version then
		return;
	elseif __emulib == nil then
		__emulib = CreateFrame('FRAME');
		__ala_meta__.__emulib = __emulib;
	else
		if __emulib.Halt ~= nil then
			__emulib:Halt();
		end
	end
	__emulib.__minor = __version;

-->

-->			upvalue
	--
	local GetTime = GetTime;
	local type, tostring, tonumber = type, tostring, tonumber;
	local wipe, concat = table.wipe, table.concat;
	local strchar, strupper, strlower, strsplit, strsub, strmatch, strfind, strrep = string.char, string.upper, string.lower, string.split, string.sub, string.match, string.find, string.rep;
	local floor, ceil = floor, ceil;
	local RegisterAddonMessagePrefix = C_ChatInfo ~= nil and C_ChatInfo.RegisterAddonMessagePrefix or RegisterAddonMessagePrefix;
	local IsAddonMessagePrefixRegistered = C_ChatInfo ~= nil and C_ChatInfo.IsAddonMessagePrefixRegistered or IsAddonMessagePrefixRegistered;
	local GetRegisteredAddonMessagePrefixes = C_ChatInfo ~= nil and C_ChatInfo.GetRegisteredAddonMessagePrefixes or GetRegisteredAddonMessagePrefixes;
	local SendAddonMessage = C_ChatInfo ~= nil and C_ChatInfo.SendAddonMessage or SendAddonMessage;
	local After = C_Timer.After;
	local Ambiguate = Ambiguate;
	local GetNumTalentGroups = GetNumTalentGroups or function() return 1; end
	local GetActiveTalentGroup = GetActiveTalentGroup or function() return 1; end
	local GetNumTalentTabs, GetNumTalents, GetTalentInfo = GetNumTalentTabs, GetNumTalents, GetTalentInfo;
	local UnitLevel = UnitLevel;
	local GetInventoryItemLink = GetInventoryItemLink;
	local GetItemInfo = GetItemInfo;
	local GetPlayerInfoByGUID = GetPlayerInfoByGUID;
	local UnitInBattleground = UnitInBattleground;
	local GetAddOnInfo, IsAddOnLoaded, GetAddOnEnableState = GetAddOnInfo, IsAddOnLoaded, GetAddOnEnableState;

	local function __table_sub(T, index, index2)
		return T[index];
	end;
	local function _log_(...)
		print(date('\124cff00ff00%H:%M:%S\124r'), ...);
		--	tinsert(logfile, { date('\124cff00ff00%H:%M:%S\124r'), ... });
	end
-->			constant
	--
	local BIG_NUMBER = 4294967295;
	local BUILD = __ala_meta__.BUILD;
	local MAX_LEVEL = __ala_meta__.MAX_LEVEL;
	--		CodingTable
	local __base64, __debase64 = {  }, {  };
		for i = 0, 9 do __base64[i] = tostring(i); end
		__base64[10] = "-";
		__base64[11] = "=";
		for i = 0, 25 do __base64[i + 1 + 11] = strchar(i + 65); end
		for i = 0, 25 do __base64[i + 1 + 11 + 26] = strchar(i + 97); end
		for i = 0, 63 do
			__debase64[__base64[i]] = i;
		end
	--
	local __classList, __classHash = { "DRUID", "HUNTER", "MAGE", "PALADIN", "PRIEST", "ROGUE", "SHAMAN", "WARLOCK", "WARRIOR", }, {  };
		if BUILD == "WRATH" then
			__classList[#__classList + 1] = "DEATHKNIGHT";
		elseif BUILD == "PANDARIA" then
			__classList[#__classList + 1] = "DEATHKNIGHT";
			__classList[#__classList + 1] = "MONK";
		elseif BUILD == "LEGION" then
			__classList[#__classList + 1] = "DEATHKNIGHT";
			__classList[#__classList + 1] = "MONK";
			__classList[#__classList + 1] = "DEAMONHUNTER";
		end
		for index = 1, #__classList do
			local class = __classList[index];
			__classHash[class] = index;
			__classHash[strupper(class)] = index;
			__classHash[strlower(class)] = index;
			__classHash[strupper(strsub(class, 1, 1)) .. strlower(strsub(class, 2))] = index;
		end
	--
	local AddOnPackList = {
		"BigFoot", "ElvUI", "Tukui", "!!!163UI!!!", "Duowan", "rLib", "NDui", "ShestakUI", "!!!EaseAddonController", "_ShiGuang",
	};
	local NumAddOnPack = #AddOnPackList;
	--
	local TALENT_REPLY_THROTTLED_INTERVAL = 1;
	local EQUIPMENT_REPLY_THROTTLED_INTERVAL = 5;
	--
	local SELFGUID = __ala_meta__.SELFGUID;
	local SELFNAME = __ala_meta__.SELFNAME;
	local SELFREALM = __ala_meta__.SELFREALM;
	local SELFFULLNAME = __ala_meta__.SELFFULLNAME;
	local SELFFULLNAME_LEN = __ala_meta__.SELFFULLNAME_LEN;
	local SELFCLASS = __ala_meta__.SELFCLASS;
	local SELFCLASSINDEX = __classHash[SELFCLASS];
	--
	local CLIENT_MAJOR = floor(__ala_meta__.TOC_VERSION / 10000);
	local ADDON_MAJOR = 2;
	--
	local COMM_PREFIX = "ATEADD";
	local COMM_PART_PREFIX = "!P" .. __base64[CLIENT_MAJOR] .. __base64[ADDON_MAJOR];
	local COMM_QUERY_PREFIX = "!Q" .. __base64[CLIENT_MAJOR] .. __base64[ADDON_MAJOR];
	local COMM_TALENT_PREFIX = "!T" .. __base64[CLIENT_MAJOR] .. __base64[ADDON_MAJOR];
	local COMM_GLYPH_PREFIX = "!G" .. __base64[CLIENT_MAJOR] .. __base64[ADDON_MAJOR];
	local COMM_EQUIPMENT_PREFIX = "!E" .. __base64[CLIENT_MAJOR] .. __base64[ADDON_MAJOR];
	local COMM_COMM_PREFIX = "!A" .. __base64[CLIENT_MAJOR] .. __base64[ADDON_MAJOR];
	----------------
	--	old version compatibility
	local COMM_CONTROL_CODE_LEN_V1 = 6;
	-- local COMM_QUERY_TALENTS_ = "_query";
	local COMM_QUERY_TALENTS_V1 = "_q_tal";
	local COMM_REPLY_TALENTS_V1_1 = "_reply";
	local COMM_REPLY_TALENTS_V1_2 = "_r_tal";
	-- local COMM_QUERY_EQUIPMENTS_1 = "_queeq";
	local COMM_QUERY_EQUIPMENTS_V1 = "_q_equ";
	local COMM_REPLY_EQUIPMENTS_V1_1 = "_repeq";
	local COMM_REPLY_EQUIPMENTS_V1_2 = "_r_equ";
	local COMM_REPLY_EQUIPMENTS_V1_3 = "_r_eq3";
	local COMM_REPLY_ADDON_PACK_V1_1 = "_reppk";
	local COMM_REPLY_ADDON_PACK_V1_2 = "_r_pak";
	local COMM_PUSH_V1 = "_push_";
	local COMM_PUSH_RECV_V1 = "_pushr";
	--
	__emulib.__classList, __emulib.__classHash = __classList, __classHash;
	--	ExposedConstant
	__emulib.CT = setmetatable(
		{  },
		{
			__index = {
				TALENT_REPLY_THROTTLED_INTERVAL = TALENT_REPLY_THROTTLED_INTERVAL,
				EQUIPMENT_REPLY_THROTTLED_INTERVAL = EQUIPMENT_REPLY_THROTTLED_INTERVAL,
				--
				CLIENT_MAJOR = CLIENT_MAJOR,
				ADDON_MAJOR = ADDON_MAJOR,
				--
				COMM_PREFIX = COMM_PREFIX,
				COMM_PART_PREFIX = COMM_PART_PREFIX,
				COMM_QUERY_PREFIX = COMM_QUERY_PREFIX,
				COMM_TALENT_PREFIX = COMM_TALENT_PREFIX,
				COMM_GLYPH_PREFIX = COMM_GLYPH_PREFIX,
				COMM_EQUIPMENT_PREFIX = COMM_EQUIPMENT_PREFIX,
				COMM_COMM_PREFIX = COMM_COMM_PREFIX,
				----------------
				--	old version compatibility
				COMM_CONTROL_CODE_LEN_V1 = COMM_CONTROL_CODE_LEN_V1,
				-- 	COMM_QUERY_TALENTS_ = COMM_QUERY_TALENTS_,
				COMM_QUERY_TALENTS_V1 = COMM_QUERY_TALENTS_V1,
				COMM_REPLY_TALENTS_V1_1 = COMM_REPLY_TALENTS_V1_1,
				COMM_REPLY_TALENTS_V1_2 = COMM_REPLY_TALENTS_V1_2,
				-- 	COMM_QUERY_EQUIPMENTS_1 = COMM_QUERY_EQUIPMENTS_1,
				COMM_QUERY_EQUIPMENTS_V1 = COMM_QUERY_EQUIPMENTS_V1,
				COMM_REPLY_EQUIPMENTS_V1_1 = COMM_REPLY_EQUIPMENTS_V1_1,
				COMM_REPLY_EQUIPMENTS_V1_2 = COMM_REPLY_EQUIPMENTS_V1_2,
				COMM_REPLY_EQUIPMENTS_V1_3 = COMM_REPLY_EQUIPMENTS_V1_3,
				COMM_REPLY_ADDON_PACK_V1_1 = COMM_REPLY_ADDON_PACK_V1_1,
				COMM_REPLY_ADDON_PACK_V1_2 = COMM_REPLY_ADDON_PACK_V1_2,
				COMM_PUSH_V1 = COMM_PUSH_V1,
				COMM_PUSH_RECV_V1 = COMM_PUSH_RECV_V1,
			},
			__newindex = {  },
		}
	);
	--
-->		NetBuffer
	--
	local MAX_PER_SLICE = 21;
	local MAX_PER_BLOCK = 210;
	local LEN_SLICE = 0.5;
	local LEN_BLOCK = 10.0;
	local Buffer = {  };
	local Pos = 1;
	local Top = 0;
	--
	local BlockSent = MAX_PER_BLOCK;
	local isFlushBlockTimerIdle = true;
	local function _BlockFlush()
		BlockSent = MAX_PER_BLOCK;
		if Top >= Pos then
			After(LEN_BLOCK, _BlockFlush);
		else
			isFlushBlockTimerIdle = true;
		end
	end
	--
	local SliceSent = MAX_PER_SLICE;
	local isFlushSliceTimerIdle = true;
	local function _SliceFlush()
		SliceSent = MAX_PER_SLICE;
		if Top >= Pos then
			while BlockSent > 0 and SliceSent > 0 do
				local b = Buffer[Pos];
				Buffer[Pos] = nil;
				SendAddonMessage(COMM_PREFIX, b[1], b[2], b[3]);
				SliceSent = SliceSent - 1;
				BlockSent = BlockSent - 1;
				Pos = Pos + 1;
				if Top < Pos then
					Pos = 1;
					Top = 0;
					break;
				end
			end
		end
		if SliceSent > 0 then
			isFlushSliceTimerIdle = true;
		else
			After(LEN_SLICE, _SliceFlush);
		end
	end
	--
	local function _SendFunc(msg, channel, target)
		if BlockSent > 0 and SliceSent > 0 then
			SliceSent = SliceSent - 1;
			BlockSent = BlockSent - 1;
			SendAddonMessage(COMM_PREFIX, msg, channel, target);
		else
			Top = Top + 1;
			Buffer[Top] = { msg, channel, target, };
		end
		if isFlushSliceTimerIdle then
			isFlushSliceTimerIdle = false;
			After(LEN_SLICE, _SliceFlush);
		end
		if isFlushBlockTimerIdle then
			isFlushBlockTimerIdle = false;
			After(LEN_BLOCK, _BlockFlush);
		end
	end
	_SliceFlush();
-->		Definition & Notes
	--[[
		numGroup = GetNumTalentGroups(inspect, pet);
		activeGroup = GetActiveTalentGroup(inspect, pet);
		NumSpecs = GetNumTalentTabs(inspect);
		NumTalents = GetNumTalents(SpecIndex, inspect);
		name, iconTexture, tier, column, rank, maxRank, isExceptional, available = GetTalentInfo(SpecIndex, TalentIndex, inspect, pet, group);

		enabled, glyphType, glyphSpell, iconFilename = GetGlyphSocketInfo(id, talentGroup);
		bool = GlyphMatchesSocket(id);
		PlaceGlyphInSocket(id);
	--]]
	--	Pack
	--		[4]		1~2		3~4		5~255
	--		!P32	b64b64	b64b64	code
	--		prefix	NumPart	Index	code
	--	Talent
	--		[4]		1		2~3		4			5			6			7~6+Len1	7+Len1		8+Len1~7+Len1+Len2
	--		!T32	b64		b64b64	b64			b64			b64			code		b64			code
	--		prefix	class	level	numGroup	activeGroup	lenTal1		Talent1		lenTal2		Talent2
	--	Glyph
	--		!G320	
	--		prefix
	--	Equip
	--		!E320	+item...
	--		prefix	item...
-->		SharedMethod
	--
	local RepeatedZero = setmetatable(
		{
			[0] = "",
			[1] = "0",
		},
		{
			__index = function(tbl, key)
				local str = strrep("0", key);
				tbl[key] = str;
				return str;
			end,
		}
	);
	local RepeatedColon = setmetatable(
		{
			[0] = "",
			[1] = ":",
		},
		{
			__index = function(tbl, key)
				local str = strrep(":", key);
				tbl[key] = str;
				return str;
			end,
		}
	);
	local function EncodeNumber(val, len)
		local __base64 = __base64;
		if val == 0 or val == nil then
			return __base64[0];
		end
		local code = nil;
		if val < 0 then
			code = "^";
			val = -val;
		else
			code = "";
		end
		local num = 0;
		while val > 0 do
			local v = val % 64;
			code = code .. __base64[v];
			num = num + 1;
			val = (val - v) / 64;
		end
		if len ~= nil and num < len then
			return code .. RepeatedZero[len - num];
		end
		return code;
	end
	local function DecodeNumber(code)
		local __debase64 = __debase64;
		local isnegative = false;
		if strsub(code, 1, 1) == "^" then
			code = strsub(code, 2);
			isnegative = true;
		end
		local v = nil;
		local n = #code;
		if n == 1 then
			v = __debase64[code];
		else
			v = 0;
			for i = n, 1, -1 do
				v = v * 64 + __debase64[strsub(code, i, i)];
			end
		end
		return isnegative and -v or v;
	end
-->		Talent		--	data = ClassIndex[b64 1char] .. TalentData[b64] .. Level[b64 2char]
	--
	local _TalentMap = {  };
	local function _GenerateTalentMap(class, inspect)
		if not inspect and class ~= SELFCLASS then
			_log_("_GenerateTalentMap", "not inspect and class ~= SELFCLASS", class, inspect);
			return nil;
		end
		local Map = _TalentMap[class];
		if Map == nil or Map.initialized == nil then
			Map = { PMap = {  }, VMap = {  }, RMap = {  }, };
			_TalentMap[class] = Map;
		end
		local PMap = Map.PMap;
		local MaxTier = -1;
		local NumSpecs = GetNumTalentTabs(inspect);
		for SpecIndex = 1, NumSpecs do
			local NumTalents = GetNumTalents(SpecIndex, inspect);
			if NumTalents == nil then
				_log_("_GenerateTalentMap", "NumTalents == nil", class, inspect, SpecIndex);
				return nil;
			end
			local PM = {  };
			PMap[SpecIndex] = PM;
			for TalentIndex = 1, NumTalents do
				local name, iconTexture, tier, column, rank, maxRank, isExceptional, available = GetTalentInfo(SpecIndex, TalentIndex, inspect);
				if rank == nil then
					_log_("_GenerateTalentMap", "rank == nil", class, inspect, SpecIndex, TalentIndex);
					return nil;
				end
				MaxTier = (tier > MaxTier) and tier or MaxTier;
				PM[tier] = PM[tier] or {  };
				PM[tier][column] = TalentIndex;
			end
		end
		local VMap = Map.VMap;
		local RMap = Map.RMap;
		for SpecIndex = 1, NumSpecs do
			local PM = PMap[SpecIndex];
			local VM = {  };
			local RM = {  };
			local TalentSeq = 0;
			VMap[SpecIndex] = VM;
			RMap[SpecIndex] = RM;
			for tier = 1, MaxTier do
				local R = PM[tier];
				if R ~= nil then
					for col = 1, 4 do
						local TalentIndex = R[col];
						if TalentIndex ~= nil then
							TalentSeq = TalentSeq + 1;
							VM[TalentSeq] = TalentIndex;
							RM[TalentIndex] = TalentSeq;
						end
					end
				end
			end
		end
		Map.initialized = true;
		return Map;
	end
	function __emulib.INSPECT_READY(GUID)
		local locClass, class, locRace, race, sex, name, realm = GetPlayerInfoByGUID(GUID);
		-- _log_("INSPECT_READY", GUID, class);
		if class ~= nil then
			_GenerateTalentMap(class, true);
		end
	end
	function __emulib.GetTalentMap(class)
		local Map = _TalentMap[class];
		if Map == nil and class == SELFCLASS then
			return _GenerateTalentMap(class, false);
		end
		return Map;
	end
	--	return 			UPPER_CLASS, data, level
	function __emulib.GetTalentData(class, inspect, group)
		local Map = __emulib.GetTalentMap(class);
		if Map == nil then
			_log_("GetTalentData", "Map == nil", class);
			return nil, 0;
		end
		local VMap = Map.VMap;
		local data = "";
		local len = 0;
		local NumSpecs = GetNumTalentTabs(inspect);
		if NumSpecs == nil then
			_log_("GetTalentData", "NumSpecs == nil", inspect);
			return nil, 0;
		end
		for SpecIndex = 1, NumSpecs do
			local VM = VMap[SpecIndex];
			if VM == nil then
				return nil, 0;
			end
			local NumTalents = GetNumTalents(SpecIndex, inspect);
			if NumTalents == nil then
				_log_("GetTalentData", "NumTalents == nil", inspect)
				return nil, 0;
			end
			len = len + NumTalents;
			for TalentSeq = 1, NumTalents do
				local TalentIndex = VM[TalentSeq];
				if TalentIndex == nil then
					_log_("GetTalentData", "TalentIndex == nil", SpecIndex, TalentSeq, TalentIndex);
					return nil, 0;
				end
				local name, iconTexture, tier, column, rank, maxRank, isExceptional, available = GetTalentInfo(SpecIndex, TalentIndex, inspect, false, group or 1);
				if rank == nil then
					_log_("GetTalentData", "rank == nil", SpecIndex, TalentSeq, TalentIndex);
					return nil, 0;
				end
				data = data .. rank;
			end
		end
		return data, len;
	end
	--	arg			code
	--	return		class
	function __emulib.GetClass(code)
		local __debase64 = __debase64;
		local cc = strsub(code, 1, 1);
		if cc == "!" then
			cc = strsub(code, 7, 7);
		end
		local classIndex = __debase64[cc];
		if classIndex == nil then
			_log_("GetClass", "classIndex == nil", code);
			return nil;
		end
		local class = __classList[classIndex];
		if class == nil then
			_log_("GetClass", "class == nil", classIndex, code);
			return nil;
		end
		return class;
	end
	--	arg			code[, len]
	--	return		data
	function __emulib.DecodeTalentBlock(code, len)
		len = len or #code;
		local data = "";
		local __debase64 = __debase64;

		local raw = 0;
		local magic = 1;
		local nChar = 0;
		for index = 1, len do
			local c = strsub(code, index, index);
			if c == ":" then
				--
			elseif __debase64[c] then
				raw = raw + __debase64[c] * magic;
				magic = magic * 64;
				nChar = nChar + 1;
			else
				_log_("DecodeTalent", 4, c, index, code);
			end
			if c == ":" or nChar == 5 or index == len then
				magic = 1;
				nChar = 0;
				local n = 0;
				while raw > 0 do
					local val = raw % 6;
					data = data .. val;
					raw = (raw - val) / 6;
					n = n + 1;
				end
				if n < 11 then
					data = data .. RepeatedZero[11 - n];
				end
			end
		end
		return data;
	end
	local _SubDecoder = {
		[1] = function(code, nodecoding)
			local __debase64 = __debase64;
			local classIndex = __debase64[strsub(code, 1, 1)];
			if classIndex == nil then
				_log_("DecodeTalent", "classIndex == nil", code);
				return nil;
			end
			local class = __classList[classIndex];
			if class == nil then
				_log_("DecodeTalent", "class == nil", classIndex, code);
				return nil;
			end

			return class, __debase64[strsub(code, -2, -2)] + __debase64[strsub(code, -1, -1)] * 64, 1, 1, __emulib.DecodeTalentBlock(strsub(code, 2, -3));
		end,
		[2] = function(code, nodecoding)
			local __debase64 = __debase64;
			local cc = strsub(code, 1, 1);
			local classIndex = __debase64[cc];
			if classIndex == nil then
				_log_("DecodeTalentDataV2", "classIndex == nil", cc, code);
				return nil;
			end
			local class = __classList[classIndex];
			if class == nil then
				_log_("DecodeTalentDataV2", "class == nil", classIndex, code);
				return nil;
			end
			local level = __debase64[strsub(code, 2, 2)] + __debase64[strsub(code, 3, 3)] * 64;
			local numGroup = tonumber(__debase64[strsub(code, 4, 4)]);
			if numGroup == nil then
				_log_("DecodeTalentDataV2", "numGroup == nil", __debase64[strsub(code, 4, 4)], code);
				return nil;
			end
			local activeGroup = tonumber(__debase64[strsub(code, 5, 5)]);
			if activeGroup == nil then
				_log_("DecodeTalentDataV2", "activeGroup == nil", __debase64[strsub(code, 5, 5)], code);
				return nil;
			end
			if numGroup < 2 then
				local lenTal1 = tonumber(__debase64[strsub(code, 6, 6)]);
				if lenTal1 == nil then
					_log_("DecodeTalentDataV2", "lenTal1 == nil", __debase64[strsub(code, 6, 6)], code);
					return nil;
				end
				local code1 = strsub(code, 7, lenTal1 + 6);
				if nodecoding == true then
					return class, level, 1, activeGroup, code1;
				else
					return class, level, 1, activeGroup, __emulib.DecodeTalentBlock(code1, lenTal1);
				end
			else
				local lenTal1 = tonumber(__debase64[strsub(code, 6, 6)]);
				if lenTal1 == nil then
					_log_("DecodeTalentDataV2", "lenTal1 == nil", __debase64[strsub(code, 6, 6)], code);
					return nil;
				end
				local code1 = strsub(code, 7, lenTal1 + 6);
				local lenTal2 = tonumber(__debase64[strsub(code, 7 + lenTal1, 7 + lenTal1)]);
				if lenTal2 == nil then
					_log_("DecodeTalentDataV2", "lenTal2 == nil", __debase64[strsub(code, 7 + lenTal1, 7 + lenTal1)], code);
					return nil;
				end
				local code2 = strsub(code, lenTal1 + 8, lenTal1 + lenTal2 + 7);
				if nodecoding == true then
					return class, level, 2, activeGroup, code1, code2;
				else
					return class, level, 2, activeGroup, __emulib.DecodeTalentBlock(code1, lenTal1), __emulib.DecodeTalentBlock(code2, lenTal2);
				end
			end
		end,
	};
	--	arg			code
	--	return		class, level, numGroup, activeGroup, data1, data2
	function __emulib.DecodeTalentDataV1(code, nodecoding)
		return _SubDecoder[1](code, nodecoding);
	end
	function __emulib.DecodeTalentDataV2(code, nodecoding)
		if strsub(code, 1, 2) ~= "!T" then
			return nil;
		end
		local __debase64 = __debase64;
		local CLIENT_MAJOR = __debase64[strsub(code, 3, 3)];
		if CLIENT_MAJOR ~= CLIENT_MAJOR then
			return nil, "WOW VERSION";
		end
		local ADDON_MAJOR = __debase64[strsub(code, 4, 4)];
		if _SubDecoder[ADDON_MAJOR] ~= nil then
			return _SubDecoder[ADDON_MAJOR](strsub(code, 5), nodecoding);
		end
		return nil, "NO DECODER";
	end
	function __emulib.DecodeTalentData(code, nodecoding)
		if strsub(code, 1, 2) == "!T" then
			return "V2", __emulib.DecodeTalentDataV2(code, nodecoding);
		else
			return "V1", __emulib.DecodeTalentDataV1(code, nodecoding);
		end
	end
	--
	--	6^11 < 64^5 < 2^32
	--	6^11 =   362,797,056		<<
	--	64^5 = 1,073,741,824
	--	6^12 = 2,176,782,336
	--	74^5 = 2,219,006,624
	--	2^32 = 4,294,967,296
	function __emulib.EncodeTalentBlock(data, len)
		if data == nil then
			return nil;
		end
		len = len or #data;
		local __base64 = __base64;
		local num = 0;
		local raw = 0;
		local magic = 1;
		local mem = {  };
		local pos = 0;
		for index = 1, len do
			local d = tonumber(data:sub(index, index));			--	table or string
			if d == nil or d == "" then
				_log_("EncodeTalentBlock", "d == nil", data, len);
				return nil;
			end
			num = num + 1;
			raw = raw + magic * d;
			magic = magic * 6;
			if num >= 11 or index == len then
				num = 0;
				magic = 1;
				local nChar = 0;
				while raw > 0 do
					local v1 = raw % 64;
					pos = pos + 1;
					mem[pos] = __base64[v1];
					raw = (raw - v1) / 64;
					nChar = nChar + 1;
				end
				if nChar < 5 then
					pos = pos + 1;
					mem[pos] = ":";
				end
			end
		end

		for i = pos, 1, - 1 do
			if mem[i] == ":" then
				mem[i] = nil;
				pos = pos - 1;
			else
				break;
			end
		end

		return concat(mem), data, pos, len;
	end
	--
	--	arg			classIndex, level, 'string', n1, n2, n3
	--	arg			classIndex, level, {t1}, {t2}, {t3}, n1, n2, n3
	--	return		code
	function __emulib.EncodeFrameDataV1(classIndex, level, D1, D2, D3, N1, N2, N3)
		local data, len = nil, nil;
		local TypeClassIndex = type(classIndex);
		if TypeClassIndex == 'string' then
			classIndex = __classHash[classIndex];
		elseif TypeClassIndex == 'number' and __classList[classIndex] then
		else
			_log_("EncodeFrameDataV1", "type(classIndex)", TypeClassIndex, classIndex);
			return nil;
		end
		if type(D1) == 'string' then
			data, len = D1, D2 + D3 + N1;
		elseif type(D1) == 'table' then
			data = { sub = __table_sub, };
			len = 0;
			for index = 1, N1 do len = len + 1; data[len] = D1 and D1[index] or 0; end
			for index = 1, N2 do len = len + 1; data[len] = D2 and D2[index] or 0; end
			for index = 1, N3 do len = len + 1; data[len] = D3 and D3[index] or 0; end
		else
			_log_("EncodeFrameData", 1, classIndex);
			return nil;
		end
		local TypeD1 = type(D1);
		if TypeD1 == 'string' then
			data, len = D1, D2 + D3 + N1;
		elseif TypeD1 == 'table' then
			data = { sub = __table_sub, };
			len = 0;
			for index = 1, N1 do len = len + 1; data[len] = D1 and D1[index] or 0; end
			for index = 1, N2 do len = len + 1; data[len] = D2 and D2[index] or 0; end
			for index = 1, N3 do len = len + 1; data[len] = D3 and D3[index] or 0; end
		else
			_log_("EncodeFrameDataV1", "type(D1)", TypeD1, classIndex);
			return nil;
		end

		return __base64[classIndex] .. __emulib.EncodeTalentBlock(data, len) .. __base64[LvLow] .. __base64[LvHigh];
	end
	function __emulib.EncodeFrameDataV2(classIndex, level, D1, D2, D3, N1, N2, N3)
		local data, len = nil, nil;
		local TypeClassIndex = type(classIndex);
		if TypeClassIndex == 'string' then
			classIndex = __classHash[classIndex];
		elseif TypeClassIndex == 'number' and __classList[classIndex] then
		else
			_log_("EncodeFrameDataV2", "type(classIndex)", TypeClassIndex, classIndex);
			return nil;
		end
		local TypeD1 = type(D1);
		if TypeD1 == 'string' then
			data, len = D1, D2 + D3 + N1;
		elseif TypeD1 == 'table' then
			data = { sub = __table_sub, };
			len = 0;
			for index = 1, N1 do len = len + 1; data[len] = D1 and D1[index] or 0; end
			for index = 1, N2 do len = len + 1; data[len] = D2 and D2[index] or 0; end
			for index = 1, N3 do len = len + 1; data[len] = D3 and D3[index] or 0; end
		else
			_log_("EncodeFrameDataV2", "type(D1)", TypeD1, classIndex);
			return nil;
		end
		level = level ~= nil and tonumber(level) or MAX_LEVEL;
		local LvLow = level % 64;
		local LvHigh = (level - LvLow) / 64;

		local __base64 = __base64;
		local code1, data1, lenc1, lend1 = __emulib.EncodeTalentBlock(data, len);
		return
				COMM_TALENT_PREFIX ..
				__base64[classIndex] ..
				__base64[LvLow] .. __base64[LvHigh] ..
				__base64[1] ..
				__base64[1] ..
				__base64[lenc1] .. code1,
				1,
				1,
				data1;
	end
	function __emulib.EncodePlayerV1()
		local level = UnitLevel('player');
		local LvLow = level % 64;
		local LvHigh = (level - LvLow) / 64;

		return __base64[SELFCLASSINDEX] .. __emulib.EncodeTalentBlock(__emulib.GetTalentData(SELFCLASS, false, 1)) .. __base64[LvLow] .. __base64[LvHigh];
	end
	function __emulib.EncodePlayerV2()
		local level = UnitLevel('player');
		local LvLow = level % 64;
		local LvHigh = (level - LvLow) / 64;
		local numGroup = GetNumTalentGroups(false, false);
		local activeGroup = GetActiveTalentGroup(false, false);

		local __base64 = __base64;
		if numGroup < 2 then
			local code1, data1, lenc1, lend1 = __emulib.EncodeTalentBlock(__emulib.GetTalentData(SELFCLASS, false, 1));
			return
					COMM_TALENT_PREFIX ..
					__base64[SELFCLASSINDEX] ..
					__base64[LvLow] .. __base64[LvHigh] ..
					__base64[numGroup] ..
					__base64[activeGroup] ..
					__base64[lenc1] .. code1,
					1,
					1,
					data1;
		else
			local code1, data1, lenc1, lend1 = __emulib.EncodeTalentBlock(__emulib.GetTalentData(SELFCLASS, false, 1));
			local code2, data2, lenc2, lend2 = __emulib.EncodeTalentBlock(__emulib.GetTalentData(SELFCLASS, false, 2));
			return
					COMM_TALENT_PREFIX ..
					__base64[SELFCLASSINDEX] ..
					__base64[LvLow] .. __base64[LvHigh] ..
					__base64[numGroup] ..
					__base64[activeGroup] ..
					__base64[lenc1] .. code1 ..
					__base64[lenc2] .. code2,
					2,
					activeGroup,
					data1,
					data2;
		end
	end
	function __emulib.EncodeInspectV1(classIndex, level)
		local TypeClassIndex = type(classIndex);
		if TypeClassIndex == 'string' then
			classIndex = __classHash[classIndex];
		elseif TypeClassIndex == 'number' and __classList[classIndex] then
		else
			_log_("EncodeFrameDataV1", "type(classIndex)", TypeClassIndex, classIndex);
			return nil;
		end
		local LvLow = level % 64;
		local LvHigh = (level - LvLow) / 64;

		return __base64[classIndex] .. __emulib.EncodeTalentBlock(__emulib.GetTalentData(__classList[classIndex], true, 1)) .. __base64[LvLow] .. __base64[LvHigh];
	end
	function __emulib.EncodeInspectV2(classIndex, level)
		local TypeClassIndex = type(classIndex);
		if TypeClassIndex == 'string' then
			classIndex = __classHash[classIndex];
		elseif TypeClassIndex == 'number' and __classList[classIndex] then
		else
			_log_("EncodeFrameDataV2", "type(classIndex)", TypeClassIndex, classIndex);
			return nil;
		end
		level = level ~= nil and tonumber(level) or MAX_LEVEL;
		local LvLow = level % 64;
		local LvHigh = (level - LvLow) / 64;
		local numGroup = GetNumTalentGroups(true, false);
		local activeGroup = GetActiveTalentGroup(true, false);

		local __base64 = __base64;
		if numGroup < 2 then
			local code1, data1, lenc1, lend1 = __emulib.EncodeTalentBlock(__emulib.GetTalentData(__classList[classIndex], true, 1));
			return
					COMM_TALENT_PREFIX ..
					__base64[classIndex] ..
					__base64[LvLow] .. __base64[LvHigh] ..
					__base64[numGroup] ..
					__base64[activeGroup] ..
					__base64[lenc1] .. code1,
					1,
					1,
					data1;
		else
			local code1, data1, lenc1, lend1 = __emulib.EncodeTalentBlock(__emulib.GetTalentData(__classList[classIndex], true, 1));
			local code2, data2, lenc2, lend2 = __emulib.EncodeTalentBlock(__emulib.GetTalentData(__classList[classIndex], true, 2));
			return
					COMM_TALENT_PREFIX ..
					__base64[classIndex] ..
					__base64[LvLow] .. __base64[LvHigh] ..
					__base64[numGroup] ..
					__base64[activeGroup] ..
					__base64[lenc1] .. code1 ..
					__base64[lenc2] .. code2,
					2,
					activeGroup,
					data1,
					data2;
		end
	end
-->		Glyph		--	only self
	--
	function __emulib.GetGlyphData(group)
		local data = "";
		for index = 1, 6 do
			local enabled, glyphType, glyphSpell, iconFilename = GetGlyphSocketInfo(id, group);
			data = (enabled and "1" or "0") .. glyphType .. glyphSpell .. iconFilename;
		end
	end
-->		Addon Pack
	--
	function __emulib.GetAddonPackData()
		local S = "a";
		for index = 1, NumAddOnPack do
			local pack = AddOnPackList[index];
			if select(5, GetAddOnInfo(pack)) ~= "MISSING" then
				local loaded, finished = IsAddOnLoaded(pack);
				if loaded then
					loaded = "~1";
				else
					loaded = "~0";
				end
				local enabled = GetAddOnEnableState(nil, pack);
				if enabled ~= nil and enabled > 0 then
					enabled = "~1";
				else
					enabled = "~0";
				end
				S = S .. "`" .. index .. enabled .. loaded;
			end
		end
		__emulib.CLocalAddOnPacks = S;
		return S;
	end
	local _ColorTable = {
		["0"] = {
			["0"] = " |cffff0000",
			["1"] = " |cffff7f00",
		},
		["1"] = {
			["0"] = " |cff007fff",
			["1"] = " |cff00ff00",
		},
	};
	function __emulib.DecodeAddonPackData(data, short)
		if data ~= nil and data ~= "" and type(data) == 'string' then
			local val = tonumber(data);
			if val then
				local got = false;
				local info = "*";
				local index = NumAddOnPack - 1;
				local magic = 2 ^ index;
				while magic >= 1 do
					if val >= magic then
						got = true;
						if short then
							info = info .. " " .. (AddOnPackList[index + 1] or "???");
						else
							info = info .. " " .. (AddOnPackList[index + 1] or "???") .. "-" .. index;
						end
						val = val - magic;
					end
					magic = magic / 2;
					index = index - 1;
				end
				if got then
					return info;
				else
					return "none";
				end
			else
				local meta = { strsplit("`", data) };
				local got = false;
				local info = "";
				for i = 1, #meta do
					local val = meta[i];
					local index, enabled, loaded = strsplit("~", val);
					if index ~= nil and enabled ~= nil and loaded ~= nil then
						index = tonumber(index);
						if index ~= nil then
							got = true;
							if short then
								info = info .. _ColorTable[enabled][loaded] .. (AddOnPackList[index] or "???") .. "|r";
							else
								info = info .. _ColorTable[enabled][loaded] .. (AddOnPackList[index] or "???") .. "-" .. index .. "|r";
							end
						end
					end
				end
				if got then
					return info;
				else
					return "none";
				end
			end
		end
	end
-->		Equipment
	--	item:id:...
	function __emulib.EncodeItem(item)
		local val = { strsplit(":", item) };
		if val[1] == "item" then
			local __base64 = __base64;
			local code = EncodeNumber(tonumber(val[2]));
			local pos = 2;
			local len = #val;
			for i = 3, len do
				if val[i] ~= "" then
					code = code .. ":" .. __base64[i - pos] .. EncodeNumber(tonumber(val[i]));
					pos = i;
				end
			end
			if pos < len then
				code = code .. ":" .. __base64[len - pos];
			end
			return code;
		end
		return "^";
	end
	function __emulib.DecodeItem(code)
		if code ~= "^" then
			local item = "item:";
			local val = { strsplit(":", code) };
			if val[1] ~= nil then
				local id = DecodeNumber(val[1]);
				if id ~= nil then
					item = item .. id;
					for i = 2, #val do
						local v = val[i];
						if #v > 1 then
							item = item .. RepeatedColon[DecodeNumber(strsub(v, 1, 1))] .. DecodeNumber(strsub(v, 2));
						else
							item = item .. RepeatedColon[v];
						end
					end
					return item;
				end
			end
		end
		return nil;
	end
	function __emulib.GetEquipmentData(data, unit)
		if data == nil then
			data = {  };
		end
		for slot = 0, 19 do
			local link = GetInventoryItemLink(unit or 'player', slot);
			if link ~= nil then
				data[slot] = strmatch(link, "\124H(item:[%-0-9:]+)\124h");
			else
				data[slot] = nil;
			end
		end
		return data;
	end
	function __emulib.EncodePlayerEquipmentDataV1(data, prefix, suffix)
		if data == nil then
			data = {  };
		else
			wipe(data);
		end
		local pos = 0;
		prefix = prefix or "";
		suffix = suffix or "";
		local limit = 255 - #prefix - #suffix;
		local msg = "";
		local len = 0;
		for slot = 0, 19 do
			local link = GetInventoryItemLink('player', slot);
			if link ~= nil then
				link = "+" .. slot .. "+" .. (strmatch(link, "\124H(item:[%-0-9:]+)\124h") or "item:-1");
			else
				link = "+" .. slot .. "+item:-1";
			end
			local ll = #link;
			if len + ll < limit then
				msg = msg .. link;
				len = len + ll;
			else
				pos = pos + 1;
				data[pos] = prefix .. msg .. suffix;
				msg = link;
				len = ll;
			end
		end
		if msg ~= "" then
			pos = pos + 1;
			data[pos] = prefix .. msg .. suffix;
		end
		return data;
	end
	function __emulib.EncodePlayerEquipmentDataV2(data, prefix, suffix, nolimit)
		if data == nil then
			data = {  };
		else
			wipe(data);
		end
		local pos = 0;
		prefix = prefix and (prefix .. COMM_EQUIPMENT_PREFIX) or COMM_EQUIPMENT_PREFIX;
		suffix = suffix or "";
		local limit = nolimit and BIG_NUMBER or (255 - #prefix - #suffix);
		local msg = EncodeNumber(0);
		local len = 0;
		for slot = 0, 19 do
			local item = GetInventoryItemLink('player', slot);
			if item ~= nil then
				item = strmatch(item, "\124H(item:[%-0-9:]+)\124h");
				if item ~= nil then
					item = "+" .. __emulib.EncodeItem(item);
				else
					item = "+^";
				end
			else
				item = "+^";
			end
			local ll = #item;
			if len + ll < limit then
				msg = msg .. item;
				len = len + ll;
			else
				pos = pos + 1;
				data[pos] = prefix .. msg .. suffix;
				msg = EncodeNumber(slot) .. item;
				len = ll;
			end
		end
		if msg ~= "" then
			pos = pos + 1;
			data[pos] = prefix .. msg .. suffix;
		end
		return data;
	end
	function __emulib.DecodeEquipmentDataV1(cache, code)
		local val = { strsplit("+", code) };	--	"", slot, item, slot, item...
		if val[3] ~= nil then
			local num = #val;
			for i = 2, num, 2 do
				local slot = tonumber(val[i]);
				local item = val[i + 1];
				local id = strmatch(item, "item:([%-0-9]+)");
				id = tonumber(id);
				if id ~= nil and id > 0 then
					GetItemInfo(id);
					cache[slot] = item;
				else
					cache[slot] = nil;
				end
			end
			return true, cache;
		end
		return false, cache;
	end
	function __emulib.DecodeEquipmentDataV2(cache, code)
		if strsub(code, 1, 2) ~= "!E" then
			return false;
		end
		local val = { strsplit("+", strsub(code, 5)) };
		if val[2] ~= nil then
			local __debase64 = __debase64;
			local start = __debase64[val[1]] - 2;
			local num = #val;
			for i = 2, num do
				local item = __emulib.DecodeItem(val[i]);
				cache[start + i] = item;
				if item ~= nil then
					GetItemInfo(item);
				end
			end
			return true, cache;
		end
		return false, cache;
	end
	function __emulib.DecodeEquipmentData(cache, code)
		if strsub(code, 1, 2) == "!E" then
			return "V2", __emulib.DecodeEquipmentDataV2(cache, code);
		else
			return "V1", __emulib.DecodeEquipmentDataV1(cache, code);
		end
	end
-->		Push
	function __emulib.PushTalentsV1(code, channel, target)
		return SendAddonMessage(COMM_PREFIX, COMM_PUSH_V1 .. code .. "#" .. SELFGUID .. "#V1", channel, target);
	end
	function __emulib.PushTalentsV2(class, level, code, channel, target)
		if type(class) == 'string' then
			class = __classHash[class];
		end
		if class == nil then
			return;
		end
		if level < 64 then
			code = __base64[class] .. code .. __base64[level] .. "0#" .. SELFGUID .. "#V2";
		else
			code = __base64[class] .. code .. __base64[bit.band(level, 63)] .. __base64[bit.rshift(level, 6)] .. "#" .. SELFGUID .. "#V2";
		end
		return SendAddonMessage(COMM_PREFIX, COMM_PUSH_V1 .. code, channel, target);
	end
	function __emulib.PushTalentsInformV1(code, channel, target)
		return SendAddonMessage(COMM_PREFIX, COMM_PUSH_RECV_V1 .. code, channel, target);
	end
-->

function __emulib.SendQueryRequest(shortname, realm, talent, equipment, glyph)
	--[~=[
	if UnitInBattleground('player') and realm ~= SELFREALM then
		if talent then
			SendAddonMessage(COMM_PREFIX, COMM_QUERY_TALENTS_V1 .. "!" .. shortname .. "-" .. realm, "INSTANCE_CHAT");
		end
		if equipment then
			SendAddonMessage(COMM_PREFIX, COMM_QUERY_EQUIPMENTS_V1 .. "!" .. shortname .. "-" .. realm, "INSTANCE_CHAT");
		end
	else
		if talent then
			SendAddonMessage(COMM_PREFIX, COMM_QUERY_TALENTS_V1 .. "!", "WHISPER", shortname .. "-" .. realm);
		end
		if equipment then
			SendAddonMessage(COMM_PREFIX, COMM_QUERY_EQUIPMENTS_V1 .. "!", "WHISPER", shortname .. "-" .. realm);
		end
	end
	--]=]
	--[=[
	if UnitInBattleground('player') and realm ~= SELFREALM then
		SendAddonMessage(COMM_PREFIX, COMM_QUERY_PREFIX .. (talent and "T" or "") .. (equipment and "E" or "") .. "#" .. shortname .. "-" .. realm, "INSTANCE_CHAT");
	else
		SendAddonMessage(COMM_PREFIX, COMM_QUERY_PREFIX .. (talent and "T" or "") .. (equipment and "E" or ""), "WHISPER", shortname .. "-" .. realm);
	end
	--]=]
end

__emulib._NumDistributors = __emulib._NumDistributors or 0;
__emulib._CommDistributor = __emulib._CommDistributor or {  };
function __emulib.RegisterCommmDistributor(Distributor, Version)
	if __emulib._CommDistributor[Distributor] == nil then
		__emulib._NumDistributors = __emulib._NumDistributors + 1;
		__emulib._CommDistributor[__emulib._NumDistributors] = Distributor;
		__emulib._CommDistributor[Distributor] = Version or -1;
	end
end


local _TThrottle = {  };		--	Talent		--	1s lock
local _EThrottle = {  };		--	Equipment	--	15s lock
local _RecvBuffer = {  };
local function _SendLongMessage(msg, channel, target)
	local len = #msg;
	if channel == "INSTANCE_CHAT" then
		local let = #target;
		if len + 1 + let <= 255 then
			return _SendFunc(msg .. "#" .. target, channel, target);
		end
		local limit = 255 - 8 - 1 - let;
		local num = ceil(len / limit);
		local d_num = EncodeNumber(num, 2);
		for index = 1, num do
			_SendFunc(COMM_PART_PREFIX .. d_num .. EncodeNumber(index, 2) .. strsub(msg, (index - 1) * limit + 1, index * limit) .. "#" .. target, channel, target);
		end
	else
		if len <= 255 then
			return _SendFunc(msg, channel, target);
		end
		local limit = 255 - 8;
		local num = ceil(len / limit);
		local d_num = EncodeNumber(num, 2);
		for index = 1, num do
			_SendFunc(COMM_PART_PREFIX .. d_num .. EncodeNumber(index, 2) .. strsub(msg, (index - 1) * limit + 1, index * limit), channel, target);
		end
	end
end
function __emulib.ProcV2Message(msg, channel, sender)
	local overheard = false;
	local _1, _2 = strsplit("#", msg);
	if _2 == nil or _2 == SELFNAME or _2 == SELFFULLNAME then
		msg = _1;
		_2 = SELFNAME;
	else
		overheard = true;
	end
	if strsub(msg, 1, 2) == "!P" then
		local num = DecodeNumber(strsub(msg, 5, 6));
		local index = DecodeNumber(strsub(msg, 7, 8));
		_RecvBuffer[_2] = _RecvBuffer[_2] or {  };
		_RecvBuffer[_2][sender] = _RecvBuffer[_2][sender] or {  };
		local Buffer = _RecvBuffer[_2][sender];
		Buffer[index] = strsub(msg, 9);
		for index = 1, num do
			if Buffer[index] == nil then
				return;
			end
		end
		_RecvBuffer[_2][sender] = nil;
		return __emulib.ProcV2Message(overheard and (concat(Buffer) .. "#" .. _2) or concat(Buffer), channel, sender);
	end
	local _;
	local pos = 1;
	local code = nil;
	local v2_ctrl_code = nil;
	local len = #msg;
	while pos < len do
		_, pos, code, v2_ctrl_code = strfind(msg, "((![^!])[^!]+)", pos);
		if v2_ctrl_code == "!Q" then
			if overheard then
				return;
			end
			local name = Ambiguate(sender, 'none');
			local now = GetTime();
			local prev = _TThrottle[name];
			if prev ~= nil and now - prev <= TALENT_REPLY_THROTTLED_INTERVAL then
				return;
			end
			local ReplyData = {  };
			for index = 3, #code do
				local v = strsub(code, index, index);
				if v == "T" then
					ReplyData[1] = __emulib.EncodePlayerV2();
				elseif v == "G" then
				elseif v == "E" then
					ReplyData[3] = __emulib.EncodePlayerEquipmentDataV2()[1];
				elseif v == "A" then
				else
				end
			end
			local msg = "";
			for index = 1, 4 do
				if ReplyData[index] ~= nil then
					msg = msg .. ReplyData[index];
				end
			end
			if msg ~= "" then
				_SendLongMessage(msg, channel, sender);
			end
		elseif v2_ctrl_code == "!T" then
			for index = 1, __emulib._NumDistributors do
				__emulib._CommDistributor[index].OnTalent(Ambiguate(sender, 'none'), code, "V2", __emulib.DecodeTalentDataV2, overheard);
			end
		elseif v2_ctrl_code == "!G" then
		elseif v2_ctrl_code == "!E" then
			for index = 1, __emulib._NumDistributors do
				__emulib._CommDistributor[index].OnEquipment(Ambiguate(sender, 'none'), code, "V2", __emulib.DecodeEquipmentDataV2, overheard);
			end
		elseif v2_ctrl_code == "!A" then
		end
	end
end
function __emulib.CHAT_MSG_ADDON(prefix, msg, channel, sender, target, zoneChannelID, localID, name, instanceID)
	if prefix == COMM_PREFIX then
		local verkey = strsub(msg, 1, 1);
		if verkey == "_" then
			local control_code = strsub(msg, 1, COMM_CONTROL_CODE_LEN_V1);
			if control_code == COMM_QUERY_TALENTS_V1 then
				local v2 = strsub(msg, COMM_CONTROL_CODE_LEN_V1 + 1, COMM_CONTROL_CODE_LEN_V1 + 1) == "!";
				local name = Ambiguate(sender, 'none');
				local now = GetTime();
				local prev = _TThrottle[name];
				if prev ~= nil and now - prev <= TALENT_REPLY_THROTTLED_INTERVAL then
					return;
				end
				--
				if channel == "INSTANCE_CHAT" then
					local target = strsub(msg, COMM_CONTROL_CODE_LEN_V1 + 2, - 1);
					if target ~= SELFFULLNAME then
						return;
					end
				end
				_TThrottle[name] = now;
				if v2 then
					local code = __emulib.EncodePlayerV2();
					if code ~= nil then
						if channel == "INSTANCE_CHAT" then
							_SendFunc(COMM_REPLY_ADDON_PACK_V1_2 .. __emulib.GetAddonPackData(), "INSTANCE_CHAT");
							_SendFunc(code .. "#" .. sender, "INSTANCE_CHAT");
						else--if channel == "WHISPER" then
							_SendFunc(COMM_REPLY_ADDON_PACK_V1_2 .. __emulib.GetAddonPackData(), "WHISPER", sender);
							_SendFunc(code, "WHISPER", sender);
						end
					end
				else
					local code = __emulib.EncodePlayerV1();
					if code ~= nil then
						if channel == "INSTANCE_CHAT" then
							_SendFunc(COMM_REPLY_ADDON_PACK_V1_2 .. __emulib.GetAddonPackData(), "INSTANCE_CHAT");
							_SendFunc(COMM_REPLY_TALENTS_V1_2 .. code .. "#" .. sender, "INSTANCE_CHAT");
						else--if channel == "WHISPER" then
							_SendFunc(COMM_REPLY_ADDON_PACK_V1_2 .. __emulib.GetAddonPackData(), "WHISPER", sender);
							_SendFunc(COMM_REPLY_TALENTS_V1_2 .. code, "WHISPER", sender);
						end
					end
				end
			elseif control_code == COMM_QUERY_EQUIPMENTS_V1 then
				local v2 = strsub(msg, COMM_CONTROL_CODE_LEN_V1 + 1, COMM_CONTROL_CODE_LEN_V1 + 1) == "!";
				local name = Ambiguate(sender, 'none');
				local now = GetTime();
				local prev = _EThrottle[name];
				if prev ~= nil and now - prev <= EQUIPMENT_REPLY_THROTTLED_INTERVAL then
					return;
				end
				--
				if channel == "INSTANCE_CHAT" then
					local target = strsub(msg, COMM_CONTROL_CODE_LEN_V1 + 2, - 1);
					if target ~= SELFFULLNAME then
						return;
					end
				end
				_EThrottle[name] = now;
				if v2 then
					local data = __emulib.EncodePlayerEquipmentDataV2(nil, nil, channel == "INSTANCE_CHAT" and ("#" .. sender) or "");
					for i = 1, #data do
						_SendFunc(data[i], channel, sender);
					end
				else
					local data = __emulib.EncodePlayerEquipmentDataV1(nil, COMM_REPLY_EQUIPMENTS_V1_3, channel == "INSTANCE_CHAT" and ("#" .. sender) or "");
					for i = 1, #data do
						_SendFunc(data[i], channel, sender);
					end
				end
			elseif __emulib._NumDistributors > 0 then
				if control_code == COMM_REPLY_TALENTS_V1_2 or control_code == COMM_REPLY_TALENTS_V1_1 then
					local code = strsub(msg, COMM_CONTROL_CODE_LEN_V1 + 1, - 1);
					if code ~= nil and code ~= "" then
						local overheard = false;
						local _1, _2 = strsplit("#", code);
						if _2 == nil or _2 == SELFNAME or _2 == SELFFULLNAME or strsub(_2, 1, SELFFULLNAME_LEN) == SELFFULLNAME then	-- OLDVERSION
							code = _1;
						else
							overheard = true;
						end
						for index = 1, __emulib._NumDistributors do
							__emulib._CommDistributor[index].OnTalent(Ambiguate(sender, 'none'), code, "V1", __emulib.DecodeTalentDataV1, overheard);
						end
					end
				elseif control_code == COMM_REPLY_EQUIPMENTS_V1_1 or control_code == COMM_REPLY_EQUIPMENTS_V1_2 or control_code == COMM_REPLY_EQUIPMENTS_V1_3 then
					local code = strsub(msg, COMM_CONTROL_CODE_LEN_V1 + 1, - 1);
					if code ~= nil and code ~= "" then
						local overheard = false;
						local _1, _2 = strsplit("#", code);
						if _2 == nil or _2 == SELFNAME or _2 == SELFFULLNAME or strsub(_2, 1, SELFFULLNAME_LEN) == SELFFULLNAME then	-- OLDVERSION
							code = _1;
						else
							overheard = true;
						end
						for index = 1, __emulib._NumDistributors do
							__emulib._CommDistributor[index].OnEquipment(Ambiguate(sender, 'none'), code, "V1", __emulib.DecodeEquipmentDataV1, overheard);
						end
					end
				elseif control_code == COMM_REPLY_ADDON_PACK_V1_2 or control_code == COMM_REPLY_ADDON_PACK_V1_1 then
					local code = strsub(msg, COMM_CONTROL_CODE_LEN_V1 + 1, - 1);
					if code ~= nil and code ~= "" then
						local overheard = false;
						local _1, _2 = strsplit("#", code);	-- OLD VERSION
						if _2 ~= nil then
							code = _1;
						end
						for index = 1, __emulib._NumDistributors do
							__emulib._CommDistributor[index].OnAddOn(Ambiguate(sender, 'none'), code, "V1", nil, overheard);
						end
					end
				elseif control_code == COMM_PUSH_V1 or control_code == COMM_PUSH_RECV_V1 then
					local code = strsub(msg, COMM_CONTROL_CODE_LEN_V1 + 1, - 1);
					if code ~= nil and code ~= "" then
						for index = 1, __emulib._NumDistributors do
							__emulib._CommDistributor[index].OnPush(Ambiguate(sender, 'none'), code, "V1", channel, zoneChannelID, control_code == COMM_PUSH_RECV_V1);
						end
					end
				end
			end
		elseif verkey == "!" and __emulib._NumDistributors > 0 then
			return __emulib.ProcV2Message(msg, channel, sender);
		--[[
			local overheard = false;
			local _1, _2 = strsplit("#", msg);
			if _2 == nil or _2 == SELFNAME or _2 == SELFFULLNAME then
				msg = _1;
				_2 = SELFNAME;
			else
				overheard = true;
			end
			if strsub(msg, 1, 2) == "!P" then
				local num = DecodeNumber(strsub(msg, 5, 6));
				local index = DecodeNumber(strsub(msg, 7, 8));
				_RecvBuffer[_2] = _RecvBuffer[_2] or {  };
				_RecvBuffer[_2][sender] = _RecvBuffer[_2][sender] or {  };
				local Buffer = _RecvBuffer[_2][sender];
				Buffer[index] = strsub(msg, 9);
				for index = 1, num do
					if Buffer[index] == nil then
						return;
					end
				end
				_RecvBuffer[_2][sender] = nil;
				return __emulib.CHAT_MSG_ADDON(COMM_PREFIX, overheard and (concat(Buffer) .. "#" .. _2) or concat(Buffer), channel, sender, target, zoneChannelID, localID, name, instanceID);
			end
			local _;
			local pos = 1;
			local code = nil;
			local v2_ctrl_code = nil;
			local len = #msg;
			while pos < len do
				_, pos, code, v2_ctrl_code = strfind(msg, "((![^!])[^!]+)", pos);
				if v2_ctrl_code == "!Q" then
					if overheard then
						return;
					end
					local name = Ambiguate(sender, 'none');
					local now = GetTime();
					local prev = _TThrottle[name];
					if prev ~= nil and now - prev <= TALENT_REPLY_THROTTLED_INTERVAL then
						return;
					end
					local ReplyData = {  };
					for index = 3, #code do
						local v = strsub(code, index, index);
						if v == "T" then
							ReplyData[1] = __emulib.EncodePlayerV2();
						elseif v == "G" then
						elseif v == "E" then
							ReplyData[3] = __emulib.EncodePlayerEquipmentDataV2()[1];
						elseif v == "A" then
						else
						end
					end
					local msg = "";
					for index = 1, 4 do
						if ReplyData[index] ~= nil then
							msg = msg .. ReplyData[index];
						end
					end
					if msg ~= "" then
						_SendLongMessage(msg, channel, sender);
					end
				elseif v2_ctrl_code == "!T" then
					for index = 1, __emulib._NumDistributors do
						__emulib._CommDistributor[index].OnTalent(Ambiguate(sender, 'none'), code, "V2", __emulib.DecodeTalentDataV2, overheard);
					end
				elseif v2_ctrl_code == "!G" then
				elseif v2_ctrl_code == "!E" then
					for index = 1, __emulib._NumDistributors do
						__emulib._CommDistributor[index].OnEquipment(Ambiguate(sender, 'none'), code, "V2", __emulib.DecodeEquipmentDataV2, overheard);
					end
				elseif v2_ctrl_code == "!A" then
				end
			end
		--]]
		--[=[
			local v2_ctrl_code = strsub(msg, 1, 2);
			if v2_ctrl_code == "!T" then
				for index = 1, __emulib._NumDistributors do
					__emulib._CommDistributor[index].OnTalent(Ambiguate(sender, 'none'), msg, "V2", __emulib.DecodeTalentDataV2);
				end
			elseif v2_ctrl_code == "!E" then
				for index = 1, __emulib._NumDistributors do
					__emulib._CommDistributor[index].OnEquipment(Ambiguate(sender, 'none'), msg, "V2", __emulib.DecodeEquipmentDataV2);
				end
			end
		--]=]
		end
	end
end

function __emulib.PLAYER_LOGIN()
	__emulib:UnregisterEvent("PLAYER_LOGIN");
	if IsAddonMessagePrefixRegistered(COMM_PREFIX) or RegisterAddonMessagePrefix(COMM_PREFIX) then
		_GenerateTalentMap(SELFCLASS, false);
	end
end

local function OnEvent(self, event, ...)
	if self[event] ~= nil then
		return self[event](...);
	end
end

__emulib:SetScript("OnEvent", OnEvent);
__emulib:RegisterEvent("PLAYER_LOGIN");
__emulib:RegisterEvent("CHAT_MSG_ADDON");
__emulib:RegisterEvent("INSPECT_READY");

function __emulib:Halt()
	__emulib:UnregisterAllEvents();
	__emulib:SetScript("OnEvent", nil);
	Pos = 1;
	Top = 0;
end


function _G.TestEquipmentV2()
	local data = __emulib.EncodePlayerEquipmentDataV2({});
	local cache = {};
	_G.print(#data, strlen(data[1]), data[1])
	for i = 1, #data do
		__emulib.DecodeEquipmentDataV2(cache, data[i]);
	end
	for i = 1, 19 do
		local item = GetInventoryItemLink('player', i);
		if item ~= nil then
			item = strmatch(item, "\124H(item:[%-0-9:]+)\124h");
			_G.print(i, cache[i] == item, cache[i]);
		else
			_G.print(i, cache[i] == nil, cache[i]);
		end
	end
end
