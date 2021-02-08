-----------------------
-- Join Notification --
-----------------------

local thisPlayer = PlayerManager:GetLocalPlayer()

Events:Subscribe('Level:Loaded', function(levelName, gameMode)

    NetEvents:Send('PlayerLoaded', thisPlayer)
    
    print('Informed server that you are loaded!')

    --thisPlayer:EnableInput(12, true)

end)

Console:Register('spawn', 'ready', function(args)

    NetEvents:Send('PlayerReady', thisPlayer)

    print('Informed server that you are ready to spawn!')

end)

Hooks:Install('UI:PushScreen', 100, function(hook, screen, priority, parentGraph, stateNodeGuid)

    local asset = UIScreenAsset(screen)

    print('UI pushing ' .. asset.name)

end)