
local detailsFramework = _G["DetailsFramework"]
if (not detailsFramework or not DetailsFrameworkCanLoad) then
	return
end

--bringing to details framework a region server which I coded few years ago for a role play gta server
--begining of the implementation

local RegionManager = {
    debugInfo = {}, --store data for region debug
    regionGrid = {},
    regionsPool = {},
    regionCacheByName = {},
    regionHandleId = 1,
    regionSquareSizeRegistered = {},
    backgroundCallback = {}, --hold callback for resources which registered to be informed about background region changes
}

--settings
--how fast the system checks which region the player is in milliseconds, default 1000
local CONST_CHECK_LOCATION_INTERVAL = 1000

--default settings for painting the region
RegionManager.squareSize = 1

--hash table with region handle as key and the region object as value
local regionsPool = RegionManager.regionsPool

--store grid coordinates information, which X Y coordinates has a region attach to
local regionsGrid = RegionManager.regionGrid

--store different square sizes of all registered regions
local registeredSquareSizes = RegionManager.regionSquareSizeRegistered

--store which regions the player is currently in that already triggered the onEnterFunc
--last zones are added at the end of the table
local regionsPlayerIsWithin = {}


--add a marker handle into the markers pool and return a handle id
local addToRegionPool = function(regionObject)
	local handleId = RegionManager.regionHandleId
	regionsPool[handleId] = regionObject
	regionObject.handleId = handleId

	--increment the handle id
	RegionManager.regionHandleId = handleId + 1

	--return the marker handle index
	return handleId
end


local removeFromRegionPool = function(handleId)
	--wipe the table
	local regionObject = regionsPool [handleId]
	if (regionObject) then
		--npt.table.wipe (regionObject)
	end

	--mark the handle as non existent
	regionsPool [handleId] = nil
end

--get the region object by the handle
local getRegionObjectByHandle = function(handleId)
	return regionsPool[handleId]
end

--get the region object by passing a region name
local getRegionObjectByName = function(regionName)
	local regionHandle = RegionManager.regionCacheByName[regionName]
	return getRegionObjectByHandle(regionHandle)
end

--return if a region exists by the region name
--function npt.RegionExists(regionName)
--	return RegionManager.regionCacheByName[regionName]
--end

