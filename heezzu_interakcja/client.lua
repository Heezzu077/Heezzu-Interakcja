local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
  }
  local PlayerData                = {}
  local PlayerLoaded              = false

  

ESX         = nil

Citizen.CreateThread(function()
    while ESX == nil do 
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

function DrawText3D(x, y, z, text, scale)
	local onScreen, _x, _y = World3dToScreen2d(x, y, z)
	local pX, pY, pZ = table.unpack(GetGameplayCamCoords())

	SetTextScale(scale, scale)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextEntry("STRING")
	SetTextCentre(1)
	SetTextColour(255, 255, 255, 255)
	SetTextOutline()

	AddTextComponentString(text)
	DrawText(_x, _y)

	local factor = (string.len(text)) / 270
	DrawRect(_x, _y + 0.015, 0.005 + factor, 0.03, 31, 31, 31, 155)
end

local timeLeft = nil
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if timeLeft ~= nil then
			local coords = GetEntityCoords(PlayerPedId())	
			DrawText3D(coords.x, coords.y, coords.z + 0.1, timeLeft .. '~g~%', 0.4)
		end
	end
end)

function procent(time, cb)
	if cb ~= nil then
		Citizen.CreateThread(function()
			timeLeft = 0
			repeat
				timeLeft = timeLeft + 1
				Citizen.Wait(time)
			until timeLeft == 100
			timeLeft = nil
			cb()
		end)
	else
		timeLeft = 0
		repeat
			timeLeft = timeLeft + 1
			Citizen.Wait(time)
		until timeLeft == 100
		timeLeft = nil
	end
end

function InterakcjaAction()
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menu', {
		title = 'Interakcja z cywilami',
		align = 'center',
		elements = {
			{label = 'Chwyć / Puść',		value = 'drag'},
			{label = 'Wsadż do pojazdu',		value = 'put_in_vehicle'},
			{label = 'Wyjmij z pojazdu',		value = 'out_the_vehicle'},
			
		}
	}, function(data, menu)

        

-------------------bez tego nie działa



		if IsPedInAnyVehicle(PlayerPedId(), false) then
		else
			if closestPlayer ~= -1 and IsEntityVisible(GetPlayerPed(closestPlayer)) and closestDistance <= 3.0 then
				local closestPed = GetPlayerPed(closestPlayer)
				if data.current.value == 'Heezzu-Interakcja' then
            if (IsPedCuffed(closestPed) or IsPlayerDead(closestPlayer)) then
                procent(15, function()
                            menu.close()
                OpenBodySearchMenu(closestPlayer)
                end)
				  end

                  


-------------------Stref Interakcji


  elseif data.current.value == 'drag' then
	ESX.ShowNotification('~o~Podnosisz osobe ~b~' .. GetPlayerServerId(closestPlayer))
		TriggerServerEvent('esx_policejob:drag', GetPlayerServerId(closestPlayer))
  end

  elseif data.current.value == 'put_in_vehicle' then
	ESX.ShowNotification('~o~Wkładasz Do Pojazdu ~b~' .. GetPlayerServerId(closestPlayer))
		TriggerServerEvent('esx_policejob:putInVehicle', GetPlayerServerId(closestPlayer))
  end

  elseif data.current.value == 'out_the_vehicle' then
	ESX.ShowNotification('~o~Wyciągasz z pojazdu ~b~' .. GetPlayerServerId(closestPlayer))
			  TriggerServerEvent('esx_policejob:OutVehicle', GetPlayerServerId(closestPlayer))
		  end
	  else
		  ESX.ShowNotification('~r~Brak graczy w pobliżu')
	  end
  end
end, function(data, menu)
  menu.close()
end)
end

Citizen.CreateThread(function()
    while true do
      Citizen.Wait(0)
      local ped = PlayerPedId()
  
      if IsControlJustPressed(1, Keys['F9']) and not IsEntityDead(ped) then
        InterakcjaAction()
      end
    end
  end)
