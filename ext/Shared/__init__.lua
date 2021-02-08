thisMap = 'sp_tank' -- There are some file names associated with SP_Tank in this code that will need to be changed as well when adapting this to different maps

-- This is bad; don't use it - it fails to remove all the sp logic, and load all the mp logic

--------------------------------------------------------
-- Allow map to be loaded (mostly Powback's code) --
--------------------------------------------------------

Events:Subscribe('Partition:Loaded', function (partition)

	if partition == nil or string.find(partition.name, thisMap) == nil then
		return
	end

    local loadedInstances = partition.instances

    for _, instance in ipairs(loadedInstances) do
        if instance == nil then
            print('Instance is null?')
            break
        end
        if(instance.typeInfo.name == "LevelDescriptionAsset") then
            local thisInstance = LevelDescriptionAsset(instance)
            thisInstance:MakeWritable()
            print('Modifying LevelDescription for ' .. partition.name)
            thisInstance.description.isCoop = false
            thisInstance.description.isMultiplayer = true
            thisInstance.description.isMenu = false
            thisInstance.description.name = "KavirDesert"

            local cat = LevelDescriptionInclusionCategory()
            print('Adding CQL as a gamemode for ' .. partition.name)
            cat.category = "GameMode"
            cat.mode:add("ConquestLarge0")
            thisInstance.categories:add(cat)
            thisInstance.startPoints:clear()
        end
        if(instance.typeInfo.name == "SubWorldReferenceObjectData") then
            local thisInstance = SubWorldReferenceObjectData(instance)
            print('Configuring autoload for ' .. partition.name)
            thisInstance:MakeWritable() 
            thisInstance.autoLoad = false                                                   -- Err
        end
        if(instance.typeInfo.name == "CameraParamsComponentData") then
            print('Setting view distance for ' .. partition.name)
            local thisInstance = CameraParamsComponentData(instance)
            thisInstance:MakeWritable()
            thisInstance.viewDistance = 100000
        end

        if(instance.typeInfo.name == "FogComponentData") then
            print('Disabling fog for ' .. partition.name)
            local thisInstance = FogComponentData(instance)
            thisInstance:MakeWritable()
            thisInstance.enable = false
        end
        if(instance.typeInfo.name == "GeometryTriggerEntityData") then
            print('Removing GeometryTriggerEntityData for ' .. partition.name)
            local thisInstance = GeometryTriggerEntityData(instance)
            thisInstance:MakeWritable()
            thisInstance.include = 0
        end
       
        if(instance.typeInfo.name == 'LevelData') then
            print('Setting level description for ' .. partition.name)
            local thisInstance = LevelData(instance)
            thisInstance:MakeWritable()
            thisInstance.levelDescription.isMultiplayer = true
            thisInstance.levelDescription.isCoop = false
            thisInstance.levelDescription.isMenu = false -- So you might have to modify two places where these parameters are set - in the LevelDescriptionAsset instance, and under the LevelData instance
        end
    end

end)

--------------------------------------------------------
-- Remove Logic References (mostly thanks to kiwidog) --
--------------------------------------------------------

Events:Subscribe('Partition:Loaded', function(partition)
    
    if partition == nil or string.find(partition.name, thisMap) == nil then
        return
    end

    local loadedInstances = partition.instances

    for _, instance in ipairs(loadedInstances) do

        if instance == nil then 
            break
        end

        if instance.typeInfo.name == 'WorldPartReferenceObjectData' then

            local logicInstance = WorldPartReferenceObjectData(instance)

            logicInstance:MakeWritable()

            local logicInstanceBp = logicInstance.blueprint

            if string.find(logicInstanceBp.name, 'Nametags') ~= nil
            or string.find(logicInstanceBp.name, 'Sound_Areas') ~= nil
            or string.find(logicInstanceBp.name, 'Sound_Areas_Schematic') ~= nil -- Doesn't run?
            or string.find(logicInstanceBp.name, 'PlayParts') ~= nil -- Doesn't run?
            or string.find(logicInstanceBp.name, 'Setup') ~= nil -- Doesn't run?
            or string.find(logicInstanceBp.name, 'Flow') ~= nil 
            or string.find(logicInstanceBp.name, 'Global_AI') ~= nil -- Doesn't run?
            or string.find(logicInstanceBp.name, 'Objectives') ~= nil 
            or string.find(logicInstanceBp.name, 'Visual_Environment') ~= nil -- This was inherited from kiwidog's code; it doesn't apply for SP_Tank, but it does for SP_Villa afaik
            or string.find(logicInstanceBp.name, 'Pathfinding') ~= nil -- This was inherited from kiwidog's code; it doesn't apply for SP_Tank, but it does for SP_Villa afaik
            or string.find(logicInstanceBp.name, 'Logic') ~= nil -- This was inherited from kiwidog's code; it doesn't apply for SP_Tank, but it does for SP_Villa afaik
            then
                print('Excluding singleplayer logic instance \'' .. logicInstanceBp.name .. '\'...')
                logicInstance.excluded = true
            end
        
        end

        if instance.typeInfo.name == 'WorldPartData' then

            local thisInstance = WorldPartData(instance)
            
            thisInstance:MakeWritable()

            if string.find(thisInstance.name, 'Flow') ~= nil or string.find(thisInstance.name, 'Setup') ~= nil then
                print('Disabling singleplayer logic WorldPartData \'' .. thisInstance.name .. '\'...')
                thisInstance.enabled = false
            end

        end

    end
    
end)

-------------------------------
-- Disabling more logic shit --
-------------------------------

Events:Subscribe('Partition:Loaded', function(partition)

    if string.find(partition.name, 'sp') == nil or string.find(partition.name, 'spawn') ~= nil or string.find(partition.name, 'abrams') ~= nil or string.find(partition.name, 'spectator') ~= nil or string.find(partition.name, 'ps3') ~= nil then 
        return
    end

    loadedInstances = partition.instances

    for _, instance in ipairs(loadedInstances) do

        -- Objectives stuff

        if instance.typeInfo.name == 'ObjectiveEntityData' then

            local thisInstance = ObjectiveEntityData(instance)
            thisInstance:MakeWritable()
            thisInstance.enabled = false
            print('Disabled ObjectiveEntityData logic instance in ' .. partition.name)

        end

        -- Flow stuff

        if instance.typeInfo.name == 'GeometryTriggerEntityData' then

            local thisInstance = GeometryTriggerEntityData(instance)
            thisInstance:MakeWritable()
            thisInstance.enabled = false
            print('Disabled GeometryTriggerEntityData logic instance in ' .. partition.name)
        
        end

        if instance.typeInfo.name == 'EventMemoryEntityData' then

            local thisInstance = EventMemoryEntityData(instance)
            thisInstance:MakeWritable()
            thisInstance.enabled = false
            print('Disabled EventMemoryEntityData logic instance in ' .. partition.name)

        end

        if instance.typeInfo.name == 'LevelControlEntityData' then

            local thisInstance = LevelControlEntityData(instance)
            thisInstance:MakeWritable()
            thisInstance.enabled = false
            print('Disabled LevelControlEntityData logic instance in ' .. partition.name)

        end

        if instance.typeInfo.name == 'LogicReferenceObjectData' then

            local thisInstance = LogicReferenceObjectData(instance)
            thisInstance:MakeWritable()
            thisInstance.excluded = true
            print('Excluded LogicReferenceObjectData logic instance in \'' .. partition.name .. '\' for \'' .. thisInstance.blueprint.name .. '\'')

        end

    end

end)

----------------------------------------
-- Remove AI etc (probably redundant) --
----------------------------------------

Events:Subscribe('Partition:Loaded', function(partition)

    if partition == nil or string.find(partition.name, thisMap) == nil then
        return
    end

    local loadedInstances = partition.instances
    
    for _, instance in ipairs(loadedInstances) do
        
        if instance == nil then
            break
        end

        if instance.typeInfo.name == 'LevelData' then
            print('Disabling AI system in ' .. partition.name)
            local thisInstance = LevelData(instance)
            thisInstance:MakeWritable()
            thisInstance.aiSystem = nil
        end
        
        -- Disable all instances of AlternateSpawnEntityData
        if instance.typeInfo.name == 'AlternateSpawnEntityData' then
            print('Disabling AI unit (AlternateSpawnEntityData) in ' .. partition.name)
            local thisInstance = AlternateSpawnEntityData(instance)
            thisInstance:MakeWritable()
            thisInstance.enabled = false
        end

        -- Disable character spawns
        if instance.typeInfo.name == 'CharacterSpawnReferenceObjectData' then
            print('Disabling AI unit (CharacterSpawnReferenceObjectData) in ' .. partition.name)
            local thisInstance = CharacterSpawnReferenceObjectData(instance)
            thisInstance:MakeWritable()
            thisInstance.enabled = false
        end

        -- Delete vehicle spawn
        if instance.typeInfo.name == 'VehicleSpawnReferenceObjectData' then
            print('Disabling vehicle unit in ' .. partition.name)
            local thisInstance = VehicleSpawnReferenceObjectData(instance)
            thisInstance:MakeWritable()
            thisInstance.enabled = false
        end

    end

end)

---------------------
-- Adding MP Files --
---------------------

-- Prepare bundles

Events:Subscribe('Level:LoadResources', function()

    print('Mounting MPChunks...')
    ResourceManager:MountSuperBundle('mpchunks')
    print('Mounting Operation Firestorm MP_012...')
    ResourceManager:MountSuperBundle('levels/mp_012/mp_012')

end)

-- Inject bundles

Hooks:Install('ResourceManager:LoadBundles', 100, function(hook, bundles, compartment)
    
    if #bundles == 1 and bundles[1] == SharedUtils:GetLevelName() then
        print('Injecting bundles...')

        bundles = {
            'levels/mp_012/mp_012',
            'levels/mp_012/conquest_large',
            'levels/mp_012/mp_012_gameconfiglight_win32',
			bundles[1],
        }

        hook:Pass(bundles, compartment)

        print('Bundles injected.')
    end

end)

-- Add registry

Events:Subscribe('Level:RegisterEntityResources', function(levelData)

    print('Adding Operation Firestorm main registry...')
    local opFirestormMainRegistry = ResourceManager:SearchForInstanceByGuid(Guid('84238275-9EEE-D74E-7D3B-6FDD6A46594A'))
    ResourceManager:AddRegistry(opFirestormMainRegistry, ResourceCompartment.ResourceCompartment_Game)
    print('Added Operation Firestorm main registry.')
    
    print('Adding Operation Firestorm (Conquest Large) registry...')
    local opFirestormCqlRegistry = ResourceManager:SearchForInstanceByGuid(Guid('320240BC-173A-5E32-CA75-51E15AC01313'))
    ResourceManager:AddRegistry(opFirestormCqlRegistry, ResourceCompartment.ResourceCompartment_Game)
    print('Added Operation Firestorm (Conquest Large) registry.')

end)

--------------------------------------
-- Add instances for Conquest Large --
--------------------------------------

Events:Subscribe('Partition:Loaded', function(partition)

    if partition.name ~= ('levels/' .. thisMap .. '/' .. thisMap) then
        return
    else
        print('Partitions ready for configuring Conquest Large instances.')
    end

    -- Create CQL instances from Operation Firestorm partition

    local firestormCqlInclusionSetting = ResourceManager:SearchForInstanceByGuid(Guid('B807651F-768F-11E2-BEA4-BBB97FE088CE'))
    local firestormCqlInclusionSettings = ResourceManager:SearchForInstanceByGuid(Guid('A097921C-F26F-4CDE-0878-A735D9D4D1F2'))
    local firestormCqlReferenceObjectData = ResourceManager:SearchForInstanceByGuid(Guid('8FE1F5F4-6C8F-4185-B478-2DDEA1CCA686'))
    local firestormCqlCommonSpawnsT1ReferenceObjectData = ResourceManager:SearchForInstanceByGuid(Guid('49CD8FA8-3A6C-4FE4-889C-7BB75E31BC7F'))
    local firestormCqlCommonSpawnsT2ReferenceObjectData = ResourceManager:SearchForInstanceByGuid(Guid('502A45B7-FC97-40B6-84F9-C6605B6AEB2B'))
    local firestormMpSchematicReferenceObjectData = ResourceManager:SearchForInstanceByGuid(Guid('83897915-59DC-44A3-921E-BCD1E29F0C69'))

    if firestormCqlInclusionSetting == nil or firestormCqlInclusionSettings == nil or firestormCqlReferenceObjectData == nil or firestormCqlCommonSpawnsT1ReferenceObjectData == nil or firestormCqlCommonSpawnsT2ReferenceObjectData == nil or firestormMpSchematicReferenceObjectData == nil then
        return
    else
        print('Found Operation Firestorm (Conquest Large) gamemode instances.')
    end
    
    local spTankCqlInclusionSetting = SubWorldInclusionSetting(firestormCqlInclusionSetting:Clone(Guid('AAAAAAAA-AAAA-AAAA-AAAA-AAAAAAAAAAAA')))
    local spTankCqlInclusionSettings = SubWorldInclusionSettings(firestormCqlInclusionSettings:Clone(Guid('BBBBBBBB-BBBB-BBBB-BBBB-BBBBBBBBBBBB')))
    spTankCqlReferenceObjectData = SubWorldReferenceObjectData(firestormCqlReferenceObjectData:Clone(Guid('CCCCCCCC-CCCC-CCCC-CCCC-CCCCCCCCCCCC')))
    local spTankCqlCommonSpawnsT1ReferenceObjectData = WorldPartReferenceObjectData(firestormCqlCommonSpawnsT1ReferenceObjectData:Clone(Guid('DDDDDDDD-DDDD-DDDD-DDDD-DDDDDDDDDDDD')))
    local spTankCqlCommonSpawnsT2ReferenceObjectData = WorldPartReferenceObjectData(firestormCqlCommonSpawnsT2ReferenceObjectData:Clone(Guid('EEEEEEEE-EEEE-EEEE-EEEE-EEEEEEEEEEEE')))
    local spTankMpSchematicReferenceObjectData = WorldPartReferenceObjectData(firestormMpSchematicReferenceObjectData:Clone(Guid('FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF')))

    partition:AddInstance(spTankCqlInclusionSetting)
    partition:AddInstance(spTankCqlInclusionSettings)
    partition:AddInstance(spTankCqlReferenceObjectData)
    partition:AddInstance(spTankCqlCommonSpawnsT1ReferenceObjectData)
    partition:AddInstance(spTankCqlCommonSpawnsT2ReferenceObjectData)
    partition:AddInstance(spTankMpSchematicReferenceObjectData)
    print('Added Conquest Large instances to main level partition.')

    -- Configure new InclusionSettings to reference the correct InclusionSetting
    spTankCqlInclusionSettings.settings:clear()
    spTankCqlInclusionSettings.settings:add(spTankCqlInclusionSetting)
    print('CQL SubWorldInclusionSettings modified to point to correct SubWorldInclusionSetting.')
    
    -- Configure new ReferenceObjectData to reference the correct InclusionSettings
    spTankCqlReferenceObjectData.inclusionSettings = spTankCqlInclusionSettings
    print('CQL SubWorldReferenceObjectData modified to point to correct SubWorldInclusionSettings.')

    -- Add required LevelData link connections

    loadedInstances = partition.instances

    for _, instance in ipairs(loadedInstances) do

        if instance == nil then 
            break
        end

        if instance.typeInfo.name == 'LevelData' then

            local thisInstance = DataBusData(instance)
            thisInstance:MakeWritable()

            -- Main link connection
            local mainReferenceObjectDataLinkConnection = LinkConnection()
            mainReferenceObjectDataLinkConnection.source = nil
            mainReferenceObjectDataLinkConnection.target = spTankCqlReferenceObjectData
            mainReferenceObjectDataLinkConnection.sourceFieldId = 0
            mainReferenceObjectDataLinkConnection.targetFieldId = 0
            thisInstance.linkConnections:add(mainReferenceObjectDataLinkConnection)
            print('Added main link connection for LevelData to CQL SubWorldReferenceObjectData.')

            -- CommonSpawnpoints link connections

            local opFirestormLevelData = LevelData(ResourceManager:SearchForInstanceByGuid(Guid('C973BE9F-14FB-A64D-BA3F-0B07A77F7E95')))
            local opFirestormLinkConnections = opFirestormLevelData.linkConnections
            opFirestormLevelData:MakeWritable()

            for i, linkConnection in ipairs(opFirestormLinkConnections) do
                if i > 48 and i < 123 then
                    local commonSpawnLinkConnection = LinkConnection(linkConnection)
                    commonSpawnLinkConnection.source = spTankCqlReferenceObjectData
                    thisInstance.linkConnections:add(commonSpawnLinkConnection)
                end
            end

            print('Added common spawnpoints link connections.')

        end

    end

    -- Add references to LevelData objects array

    for _, instance in ipairs(loadedInstances) do

        if instance == nil then 
            break
        end

        if instance.typeInfo.name == 'LevelData' then

            local thisInstance = PrefabBlueprint(instance)
            thisInstance:MakeWritable()
            thisInstance.objects:add(spTankCqlReferenceObjectData)
            thisInstance.objects:add(spTankCqlCommonSpawnsT1ReferenceObjectData)
            thisInstance.objects:add(spTankCqlCommonSpawnsT2ReferenceObjectData)
            thisInstance.objects:add(spTankMpSchematicReferenceObjectData)
            print('Added CQL SubWorldReferenceObjectData references to LevelData \'Objects\' array.')

        end

    end

end)

-- Create a registry to house the CQL SubWorldReferenceData

Events:Subscribe('Level:RegisterEntityResources', function(levelData)

    print('Adding new registry containing CQL SubWorldReferenceData...')
    local cqlDataRegistry = RegistryContainer()
    cqlDataRegistry.referenceObjectRegistry:add(spTankCqlReferenceObjectData)
    ResourceManager:AddRegistry(cqlDataRegistry, ResourceCompartment.ResourceCompartment_Game)
    print('Added new registry containing CQL SubWorldReferenceData.')

end)

--------------------------------------------------------------------
-- Modify CQL partition to customise flag positions, spawns, etc. --
--------------------------------------------------------------------

Events:Subscribe('Partition:Loaded', function(partition)

    if partition == nil or partition.name ~= 'levels/mp_012/conquest_large' then
        return
    else
        print('Operation Firestorm (Conquest Large) gamemode partition found for modification.')
    end

    -- Cross this bridge when we come to it - hopefully the map is big enough that this shouldn't be an issue

end)