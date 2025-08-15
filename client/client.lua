-- Carga los frameworks necesarios según configuración
if Config.framework == 'qbcore' then
    QBCore = exports['qb-core']:GetCoreObject()
elseif Config.framework == 'esx' then
    TriggerEvent('esx:getSharedObject', function(obj)
        ESX = obj
    end)
elseif Config.framework == 'custom' then
    -- Importa tu framework
end

local speakers = {}
local isInUI = false
local playlistsLoaded = false
local reproInUi = -1
local movingASpeaker = false
local movingObject = 0
local movingSpeakerId = -1
local gangAnim = true
local currentTextUI = nil -- Nueva variable para rastrear el TextUI actual

Cbs = {}

RegisterNetEvent('TriggerCallback', function(name, ...)
    if Cbs[name] then
        Cbs[name](...)
        Cbs[name] = nil
    end
end)

function TriggerCallback(name, cb, ...)
    Cbs[name] = cb
    TriggerServerEvent('TriggerCallback', name, ...)
end

-- Función para mostrar notificaciones de ayuda
local function ShowHelpNotification(msg)
    if Config.useCustomTextUI == 'qbcore' then
        exports['qb-core']:DrawText(msg, 'left')
    elseif Config.useCustomTextUI == 'esx' then
        ESX.ShowHelpNotification(msg)
    elseif Config.useCustomTextUI == 'dp' then
        -- Solo mostramos si no están ya visibles
        if currentTextUI ~= 'multiple_help' then
            exports['DP-TextUI']:OcultarUI('acceder')
            exports['DP-TextUI']:OcultarUI('recoger')
            exports['DP-TextUI']:OcultarUI('cogerlo')

            -- Muestra los tres TextUI independientes
            exports['DP-TextUI']:MostrarUI('acceder', 'Acceder al altavoz', 'E', false)
            exports['DP-TextUI']:MostrarUI('recoger', 'Recogerlo', 'BACKSPACE', false)
            exports['DP-TextUI']:MostrarUI('cogerlo', 'Cogerlo en hombros', 'K', false)

            currentTextUI = 'multiple_help'
        end
    elseif Config.useCustomTextUI == 'default' then
        AddTextEntry('HelpNotification', msg)
        BeginTextCommandDisplayHelp('HelpNotification')
        EndTextCommandDisplayHelp(0, false, true, -1)
    elseif Config.useCustomTextUI == 'custom' then
        -- Implementación custom
    end
end

-- Función para ocultar el TextUI
local function HideTextUI()
    if Config.useCustomTextUI == 'qbcore' then
        exports['qb-core']:HideText()
    elseif Config.useCustomTextUI == 'esx' then
        ESX.HideHelpNotification()
    elseif Config.useCustomTextUI == 'dp' then
        -- Oculta todos los TextUI relacionados
        exports['DP-TextUI']:OcultarUI('acceder')
        exports['DP-TextUI']:OcultarUI('recoger')
        exports['DP-TextUI']:OcultarUI('cogerlo')
        exports['DP-TextUI']:OcultarUI('dejar')
        exports['DP-TextUI']:OcultarUI('cambiar_anim')
        currentTextUI = nil
    elseif Config.useCustomTextUI == 'default' then
        AddTextEntry('HideHelpNotification', ' ')
        BeginTextCommandDisplayHelp('HideHelpNotification')
        EndTextCommandDisplayHelp(0, false, true, -1)
    elseif Config.useCustomTextUI == 'custom' then
        -- Implementación custom
    end
end

function ShowNotification(msg, notifyType)
    if Config.useQBCoreNotify then
        QBCore.Functions.Notify(msg, notifyType or 'primary', 5000)
    else
        -- Método antiguo (GTA default)
        SetNotificationTextEntry('STRING')
        AddTextComponentSubstringPlayerName(msg)
        DrawNotification(false, true)
    end
end

function SendReactMessage(action, data)
    SendNUIMessage({
        action = action,
        data = data
    })
end

local function toggleNuiFrame(shouldShow)
    SetNuiFocus(shouldShow, shouldShow)
    isInUI = shouldShow
    SendReactMessage('setVisible', shouldShow)
    if shouldShow == false then
        reproInUi = -1
    end
end

RegisterNUICallback('hideFrame', function(_, cb)
    toggleNuiFrame(false)
    cb({})
end)

function LoadSpeakers()
    TriggerCallback('DP-Boombox:callback:getBoomboxs', function(result)
        SendReactMessage('createReproGlobal', result)
        Wait(200)
        speakers = result
    end)
end

RegisterNUICallback('webLoaded', function()
    Wait(100)
    LoadSpeakers()
end)

RegisterNUICallback('playSong', function(data)
    TriggerServerEvent('DP-Boombox:server:Playsong', data)
end)

RegisterNUICallback('getNewPlaylist', function(data, cb)
    TriggerCallback('DP-Boombox:callback:getNewPlaylist', function(result)
        cb(result)
    end, data)
end)

RegisterNetEvent('DP-Boombox:client:notify', function(msg)
    ShowNotification(msg)
end)

RegisterNUICallback('tempChangeVolume', function(data)
    speakers[data.repro + 1].volume = data.volume
end)

RegisterNUICallback('changeDist', function(data)
    TriggerServerEvent('DP-Boombox:server:SyncNewDist', data)
end)

RegisterNUICallback('syncVolume', function(data)
    TriggerServerEvent('DP-Boombox:server:SyncNewVolume', data)
end)

RegisterNUICallback('deletePlayList', function(data)
    TriggerServerEvent('DP-Boombox:server:deletePlayList', data)
end)

RegisterNUICallback('importNewPlaylist', function(data)
    TriggerServerEvent('DP-Boombox:server:importNewPlaylist', data)
end)

RegisterNetEvent('DP-Boombox:client:updateBoombox', function(id, data)
    speakers[id] = data
    if (id - 1) == reproInUi then
        SendReactMessage('sendSongInfo', {
            author = speakers[id].playlistPLaying.songs[speakers[id].songId].author,
            name = speakers[id].playlistPLaying.songs[speakers[id].songId].name,
            url = speakers[id].url,
            volume = speakers[id].volume,
            dist = speakers[id].maxDistance,
            maxDuration = speakers[id].maxDuration,
            paused = speakers[id].paused,
            pausedTime = speakers[id].pausedTime
        })
    end
end)

RegisterNetEvent('DP-Boombox:client:updateVolume', function(id, vol)
    speakers[id].volume = vol
end)

RegisterNetEvent('DP-Boombox:client:updateDist', function(id, dist)
    speakers[id].maxDistance = dist
end)

RegisterNetEvent('DP-Boombox:client:doAnim', function()
    if not HasAnimDictLoaded('anim@heists@money_grab@briefcase') then
        RequestAnimDict('anim@heists@money_grab@briefcase')

        while not HasAnimDictLoaded('anim@heists@money_grab@briefcase') do
            Citizen.Wait(1)
        end
    end
    TaskPlayAnim(PlayerPedId(), 'anim@heists@money_grab@briefcase', 'put_down_case', 8.0, -8.0, -1, 1, 0, false, false,
        false)
    Citizen.Wait(1000)
    ClearPedTasks(PlayerPedId())
end)

RegisterNetEvent('DP-Boombox:client:insertSpeaker', function(data)
    table.insert(speakers, data)
    SendReactMessage('createRepro', data.url)
end)

RegisterNetEvent('DP-Boombox:client:deleteBoombox', function(id)
    speakers[id].permaDisabled = true
end)

RegisterNUICallback('prevSong', function(data)
    if data.repro == reproInUi then
        TriggerServerEvent('DP-Boombox:server:prevSong', data)
    end
end)

RegisterNUICallback('nextSong', function(data)
    if data.repro == reproInUi then
        TriggerServerEvent('DP-Boombox:server:nextSong', data)
    end
end)

RegisterNUICallback('pauseSong', function(data)
    if data.repro == reproInUi then
        TriggerServerEvent('DP-Boombox:server:pauseSong', data)
    end
end)

RegisterNUICallback('syncNewTime', function(data)
    if data.repro == reproInUi then
        TriggerServerEvent('DP-Boombox:server:syncNewTime', data)
    end
end)

function LoadAnima()
    if not HasAnimDictLoaded('missfinale_c2mcs_1') then
        RequestAnimDict('missfinale_c2mcs_1')

        while not HasAnimDictLoaded('missfinale_c2mcs_1') do
            Citizen.Wait(1)
        end
    end
end

Citizen.CreateThread(function()
    while true do
        local sleep = 500
        local player = PlayerPedId()
        local playerCoords = GetEntityCoords(player)
        local speakerInRange = false
        local shouldShowHelp = false -- Nueva variable para controlar la visibilidad

        for k, v in pairs(speakers) do
            local distance = #(v.coords - playerCoords)
            if distance < v.maxDistance + 10 and sleep >= 100 then
                sleep = 100
            end
            if distance < v.maxDistance and not v.permaDisabled then
                sleep = 5
                if not v.isPlaying and v.url ~= '' and not v.paused then
                    SendReactMessage('playSong', {
                        repro = tonumber(k - 1),
                        url = v.url,
                        volume = v.volume,
                        time = v.time
                    })
                    v.isPlaying = true
                end
                if not v.paused then
                    SendReactMessage('changeVolume', {
                        repro = tonumber(k - 1),
                        volume = tonumber(v.volume - (distance * v.volume / v.maxDistance))
                    })
                else
                    SendReactMessage('changeVolume', {
                        repro = tonumber(k - 1),
                        volume = 0
                    })
                end
                if distance < 1.5 and not v.isMoving then
                    if not movingASpeaker then
                        speakerInRange = true
                        shouldShowHelp = true -- Marcar que debemos mostrar ayuda
                    end

                    if IsControlJustPressed(1, Config.KeyAccessUi) and not movingASpeaker then
                        HideTextUI() -- Oculta el TextUI al abrir la UI
                        SendReactMessage('setRepro', tonumber(k - 1))
                        if not playlistsLoaded then
                            SendReactMessage('getPlaylists')
                        end
                        if v.playlistPLaying.songs and v.playlistPLaying.songs[v.songId] then
                            SendReactMessage('sendSongInfo', {
                                author = v.playlistPLaying.songs[v.songId].author,
                                name = v.playlistPLaying.songs[v.songId].name,
                                url = v.url,
                                volume = v.volume,
                                dist = v.maxDistance,
                                maxDuration = v.maxDuration,
                                paused = v.paused,
                                pausedTime = v.pausedTime
                            })
                        end
                        toggleNuiFrame(true)
                        reproInUi = k - 1
                    end
                    if IsControlJustPressed(1, Config.KeyDeleteSpeaker) and not isInUI and not movingASpeaker then
                        HideTextUI()
                        TriggerServerEvent('DP-Boombox:server:deleteBoombox', k, v.coords.x)
                        Wait(200)
                    end
                    if IsControlJustPressed(1, Config.KeyToMove) and not movingASpeaker then
                        HideTextUI()
                        TriggerCallback('DP-Boombox:callback:canMove', function(canMove)
                            if canMove then
                                movingASpeaker = true
                                local ped = PlayerPedId()
                                local x, y, z = table.unpack(GetOffsetFromEntityInWorldCoords(ped, 0.0, 3.0, 0.5))
                                local obj = CreateObjectNoOffset('prop_boombox_01', x, y, z, true, false)
                                SetModelAsNoLongerNeeded('prop_boombox_01')
                                movingObject = obj
                                movingSpeakerId = k
                                if gangAnim then
                                    LoadAnima()
                                    TaskPlayAnim(PlayerPedId(), 'missfinale_c2mcs_1', 'fin_c2_mcs_1_camman', 8.0, -8.0,
                                        -1, 51, 0, false, false, false)
                                    AttachEntityToEntity(obj, ped, GetPedBoneIndex(ped, 28422), 0.0, 0.0, 0.1, 0.0, 0.0,
                                        0.0, true, true, false, true, 1, true)
                                else
                                    AttachEntityToEntity(obj, ped, GetPedBoneIndex(ped, 57005), 0.32, 0, -0.05, 0.10,
                                        270.0, 60.0, true, true, false, true, 1, true)
                                end
                            end
                        end, k)
                    end
                end
            else
                if v.isPlaying then
                    SendReactMessage('stopSong', tonumber(k - 1))
                    v.isPlaying = false
                end
            end
            if v.isMoving then
                if v.playerMoving >= 1 then
                    local playerIdx = GetPlayerFromServerId(v.playerMoving)
                    local ped = GetPlayerPed(playerIdx)
                    local coords = GetEntityCoords(ped)
                    if coords == GetEntityCoords(PlayerPedId()) then
                        if movingASpeaker and k == movingSpeakerId then
                            v.coords = coords
                        end
                    else
                        v.coords = coords
                    end
                end
            end
        end
        -- Control de visibilidad de los TextUI
        if Config.useCustomTextUI == 'dp' then
            if shouldShowHelp and not isInUI and not movingASpeaker then
                if currentTextUI ~= 'multiple_help' then
                    ShowHelpNotification(Config.Translations.helpNotify)
                end
            elseif not shouldShowHelp and currentTextUI == 'multiple_help' then
                HideTextUI()
            end
        end

        -- Modifica la sección de movingASpeaker para usar el sistema correspondiente:
        if movingASpeaker then
            sleep = 5

            if Config.useCustomTextUI == 'qbcore' then
                exports['qb-core']:DrawText(Config.Translations.holdingBoombox, 'left')
            elseif Config.useCustomTextUI == 'esx' then
                ESX.ShowHelpNotification(Config.Translations.holdingBoombox)
            elseif Config.useCustomTextUI == 'dp' then
                -- Oculta los UI de ayuda si estaban visibles
                exports['DP-TextUI']:OcultarUI('acceder')
                exports['DP-TextUI']:OcultarUI('recoger')
                exports['DP-TextUI']:OcultarUI('cogerlo')

                -- Muestra los dos TextUI independientes para mover
                if currentTextUI ~= 'holding_boombox' then
                    exports['DP-TextUI']:OcultarUI('dejar')
                    exports['DP-TextUI']:OcultarUI('cambiar_anim')

                    exports['DP-TextUI']:MostrarUI('dejar', 'Dejarlo en el suelo', 'ENTER', false)
                    exports['DP-TextUI']:MostrarUI('cambiar_anim', 'Cambiar animación', 'K', false)

                    currentTextUI = 'holding_boombox'
                end
            elseif Config.useCustomTextUI == 'default' then
                AddTextEntry('HoldingBoombox', Config.Translations.holdingBoombox)
                BeginTextCommandDisplayHelp('HoldingBoombox')
                EndTextCommandDisplayHelp(0, false, true, -1)
            elseif Config.useCustomTextUI == 'custom' then
                -- Implementación custom
            end

            if IsControlJustPressed(1, Config.KeyToPlaceSpeaker) then
                HideTextUI()
                if not HasAnimDictLoaded('anim@heists@money_grab@briefcase') then
                    RequestAnimDict('anim@heists@money_grab@briefcase')

                    while not HasAnimDictLoaded('anim@heists@money_grab@briefcase') do
                        Citizen.Wait(1)
                    end
                end
                TaskPlayAnim(PlayerPedId(), 'anim@heists@money_grab@briefcase', 'put_down_case', 8.0, -8.0, -1, 1, 0,
                    false, false, false)
                Citizen.Wait(1000)
                ClearPedTasks(PlayerPedId())
                DeleteEntity(movingObject)
                TriggerServerEvent('DP-Boombox:server:updateObjectCoords', movingSpeakerId)
                movingSpeakerId = 0
                movingASpeaker = false
            end
            if IsControlJustPressed(1, Config.KeyToChangeAnim) then
                gangAnim = not gangAnim
                if gangAnim then
                    LoadAnima()
                    AttachEntityToEntity(movingObject, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 28422), 0.0, 0.0,
                        0.1, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
                    TaskPlayAnim(PlayerPedId(), 'missfinale_c2mcs_1', 'fin_c2_mcs_1_camman', 8.0, -8.0, -1, 51, 0,
                        false, false, false)
                else
                    ClearPedTasks(PlayerPedId())
                    AttachEntityToEntity(movingObject, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.32, 0,
                        -0.05, 0.10, 270.0, 60.0, true, true, false, true, 1, true)
                end
            end
        else
            -- Si no se está moviendo y no hay altavoz en rango, oculta el TextUI
            if not speakerInRange and not isInUI and currentTextUI then
                HideTextUI()
            end
        end

        Wait(sleep)
    end
end)

RegisterNetEvent('DP-Boombox:client:updatePlayerMoving', function(id, src)
    speakers[id].isMoving = true
    speakers[id].playerMoving = src
end)

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    DeleteEntity(movingObject)
end)

RegisterNUICallback('getPlaylists', function(_, cb)
    TriggerCallback('DP-Boombox:callback:getPlaylists', function(result)
        cb(result)
    end)
end)

RegisterNetEvent('DP-Boombox:client:syncLastCoords', function(id, coords)
    speakers[id].coords = coords
    speakers[id].isMoving = false
    speakers[id].playerMoving = -2
end)

RegisterNetEvent('DP-Boombox:client:syncLastCoordsSync', function(id, coords)
    speakers[id].coords = coords
end)

RegisterNUICallback('addSong', function(data)
    TriggerServerEvent('DP-Boombox:server:addSong', data)
end)

RegisterNUICallback('deleteSongPlaylist', function(data)
    TriggerServerEvent('DP-Boombox:server:deleteSongPlaylist', data)
end)

RegisterNetEvent('DP-Boombox:client:resyncPlaylists', function()
    SendReactMessage('getPlaylists')
end)

RegisterNUICallback('getLibraryLabel', function(_, cb)
    cb(Config.Translations.libraryLabel)
end)

RegisterNUICallback('newPlaylistLabel', function(_, cb)
    cb(Config.Translations.newPlaylistLabel)
end)

RegisterNUICallback('playlistName', function(_, cb)
    cb(Config.Translations.playlistName)
end)

RegisterNUICallback('addSongLabel', function(_, cb)
    cb(Config.Translations.addSong)
end)

RegisterNUICallback('deletePlaylistLabel', function(_, cb)
    cb(Config.Translations.deletePlaylist)
end)

RegisterNUICallback('importPlaylistLabel', function(_, cb)
    cb(Config.Translations.importPlaylistLabel)
end)

RegisterNUICallback('Unkown', function(_, cb)
    cb(Config.Translations.unkown)
end)

RegisterNUICallback('titleFirstMessage', function(_, cb)
    cb(Config.Translations.titleFirstMessage)
end)

RegisterNUICallback('secondFirstMessage', function(_, cb)
    cb(Config.Translations.secondFirstMessage)
end)

RegisterNUICallback('timeZone', function(_, cb)
    cb(Config.timeZone)
end)

RegisterCommand(Config.fixSpeakersCommand, function()
    LoadSpeakers()
end)
