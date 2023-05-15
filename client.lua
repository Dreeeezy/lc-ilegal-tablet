-- ESX = nil

-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONEXÃO
-----------------------------------------------------------------------------------------------------------------------------------------
src = {}
Tunnel.bindInterface("lc_ilegalmkt",src)

vSERVER = Tunnel.getInterface("lc_ilegalmkt")



local TE = TriggerEvent
local TSE = TriggerServerEvent
local job = nil
local isMarketOpen = false
local blipsLoaded = false


if not Config.UseBlipToAccessMarket then
	RegisterCommand(Config.MarketCommand, function()
		TE('lc_ilegalmkt:open') ---- Function para abrir o tablet sem precisar de comando (como exemplo um item chamar a trigger)
	end, false)
else
	Citizen.CreateThread(function()
		if Config.ShowBlipsOnMap then
			Citizen.Wait(2000)
			for k,v in ipairs(Config.BlipCoords) do
				local blip = AddBlipForCoord(v.x, v.y, v.z)
				SetBlipSprite(blip, v.blipId)
				SetBlipDisplay(blip, 4)
				SetBlipScale(blip, v.blipScale)
				SetBlipColour(blip, v.blipColor)
				SetBlipAsShortRange(blip, true)
				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString(v.blipText)
				EndTextCommandSetBlipName(blip)
			end
		end
	end)

	Citizen.CreateThread(function()
		if not blipsLoaded then
			blipsLoaded = true
			Citizen.Wait(2000)
			local playerPed = GetPlayerPed(-1)
			local waitMoreTime = true
			local playerExists = false
			while Config.ShowFloorBlips do
				Citizen.Wait(5)
				if not playerExists then
					if DoesEntityExist(playerPed) then
						playerExists = true
					else
						playerPed = GetPlayerPed(-1)
					end
				end

				if playerExists then
					local playerCoords = GetEntityCoords(PlayerPedId())

					if waitMoreTime then
						waitMoreTime = false
					end
					
					for k,v in pairs(Config.BlipCoords) do
						local distance = GetDistanceBetweenCoords(playerCoords.x, playerCoords.y, playerCoords.z, v.x, v.y, v.z)
						if distance < v.showMarkerRadius then
							DrawMarker(v.MarkerID, v.x, v.y, v.z-0.0, 0, 0, 0, 0, 0, 0, 0.75, 0.75, 0.75, 31, 94, 255, 155, 0, 0, 2, 1, 0, 0, 0)
						end
					end
				end

				if waitMoreTime then
					Citizen.Wait(1000)
				end
			end
		end
	end)

	Citizen.CreateThread(function()
		local inZone = false
		local nearZone = false
		local enteredRange = false
		local inWideRange = false

		while true do
			Citizen.Wait(5)
			local playerCoords = GetEntityCoords(PlayerPedId())
			
			nearZone = false
			inZone = false

			for k,v in pairs(Config.BlipCoords) do
				local distance = GetDistanceBetweenCoords(playerCoords.x, playerCoords.y, playerCoords.z, v.x, v.y, v.z)
			
				if distance < v.radius + 2 then
					local height = playerCoords.z - v.z
					nearZone = true
					if waitMore and not isMarketOpen then
						waitMore = false
					elseif not waitMore and isMarketOpen then
						waitMore = true
					end
					
					if distance < v.radius and height < 3 and height > -3 then
						inZone = true
						-- if not Config.UseOkokTextUI and not isMarketOpen then
						-- 	ESX.ShowHelpNotification('~INPUT_CONTEXT~ To open the marketplace')
						-- end

						if IsControlJustReleased(0, Config.OpenMarketKey) then
							if GetVehiclePedIsUsing(PlayerPedId()) == 0 then
								TE('lc_ilegalmkt:open')
							else
								TriggerEvent("Notify", "amarelo", "Você não pode acessar o mercado dentro de um veículo", 5000)
							end
						end
					end
				elseif not waitMore and not inWideRange then
					waitMore = true
				end
			end

			if nearZone and not enteredRange then
				enteredRange = true
				inWideRange = true
			elseif not nearZone and enteredRange then
				enteredRange = false
				inWideRange = false
			end

			if inZone and not hasEntered then
				-- if Config.UseOkokTextUI then
				-- 	exports['okokTextUI']:Open('[E] To open the Marketplace', 'darkblue', 'left') 
				-- end
				hasEntered = true
			elseif not inZone and hasEntered then
				-- if Config.UseOkokTextUI then
				-- 	exports['okokTextUI']:Close()
				-- end
				hasEntered = false
			end 

			if waitMore then
				Citizen.Wait(1000)
			end
		end
	end)
end

RegisterNetEvent("lc_ilegalmkt:open")
AddEventHandler("lc_ilegalmkt:open", function()
	local vehiclesTable = {}
	local itemsTable = {}
	local blackmarketTable = {}
	local accessBlackmarket = false
	if not isMarketOpen then
			-- vSERVER.getItems(items)

			local items = vSERVER.getItems()


			table.insert(vehiclesTable, {vehicle = "Indisponível", plate = "XXX-XXX", name = "Indisponível"})




			-- for k,v in ipairs(vehicles) do
			-- 	local canAdd = true
			-- 	for k2,v2 in ipairs(Config.BlacklistVehicles) do
			-- 		if GetDisplayNameFromVehicleModel(v.vehicle.model) == v2 then
			-- 			canAdd = false
			-- 			break
			-- 		end
			-- 	end

			-- 	if canAdd then
			-- 		table.insert(vehiclesTable, {vehicle = v.vehicle, plate = v.plate, name = GetDisplayNameFromVehicleModel(v.vehicle.model)})
			-- 	end
			-- end

			-- print(json.encode(items))
			-- print(items)

			-- local items = {"maconha",2}

			for k,v in pairs(items) do
				local canAdd = true
				local blackmarketItem = false
				if v.amount > 0 then

					for k2,v2 in ipairs(Config.BlacklistItems) do
						if v.item == v2 then
							canAdd = false
							break
						end
					end

					if canAdd then
						table.insert(itemsTable, {id = v.item, label = vSERVER.getItemInfos(v.item), count = vSERVER.getItemParseVal(v.amount)})
					-- else
					-- 	for k2,v2 in ipairs(Config.Blackmarket) do
					-- 		if v.name == v2[1] and not v2[2] then
					-- 			blackmarketItem = true
					-- 			break
					-- 		end
					-- 	end

					-- 	if blackmarketItem then
					-- 		table.insert(blackmarketTable, {id = v.name, label = v.label, count = v.count, type = "item"})
					-- 	end
					end
				end
			end

			-- for k,v in ipairs(loadout) do
			-- 	for k2,v2 in ipairs(Config.Blackmarket) do
			-- 		if v.name == v2[1] and v2[2] then
			-- 			table.insert(blackmarketTable, {id = v.name, label = v.label, count = 1, type = "weapon"})
			-- 		end
			-- 	end
			-- end
			
			-- vSERVER.getAds(vehAds, itemsAds, blackmarketAds, identifier)

			local vehAds1 = {}
			local identifier = vSERVER.getIdentifer()

				-- local vehAds1 = {}
				local itemsAds1 = {}
				local blackmarketAds1 = {}
				local myAds = {}

				-- for k,v in ipairs(vehAds) do
				-- 	if v.author_identifier ~= identifier then
				-- 		if not v.sold then
				-- 			table.insert(vehAds1, v)
				-- 		end
				-- 	else
				-- 		table.insert(myAds, v)
				-- 	end
				-- end

				-- print(json.encode(itemsAds))
				local itemsAds = vSERVER.getItemAds()



				local myAds = vSERVER.getMyAds()

				
				for k,v in pairs(itemsAds) do
					if identifier then
						if not v.sold then
							-- print('chegou aq 1')


							table.insert(itemsAds1, v)
						end
					else
						-- print('chegou aq 2')
						table.insert(myAds, v)
					end
				end


				-- print(json.encode(myAds))

				-- local blackmarketAds = {}
				-- for k,v in ipairs(blackmarketAds) do
				-- 	if identifier then
				-- 		if not v.sold then
				-- 			table.insert(blackmarketAds1, v)
				-- 		end
				-- 	else
				-- 		table.insert(myAds, v)
				-- 	end
				-- end

				-- for k,v in ipairs(Config.BlackmarketAllowedJobs) do
				-- 	if v.job == job.name then
				-- 		if v.grade[1] == nil then
				-- 			accessBlackmarket = true
				-- 			break
				-- 		else
				-- 			for k2,v2 in ipairs(v.grade) do
				-- 				if v2 == job.grade_name then
				-- 					accessBlackmarket = true
				-- 					break
				-- 				end
				-- 			end
				-- 			break
				-- 		end
				-- 	end
				-- end
				isMarketOpen = true
				SetNuiFocus(true, true)
				SendNUIMessage({
					action = 'openVehicleMarket',
					vehicles = vehiclesTable,
					vehAds = vehAds1,
					items = itemsTable,
					itemsAds = itemsAds1,
					blackmarket = blackmarketTable,
					blackmarketAds = blackmarketAds1,
					myAds = myAds,
					accessBlackmarket = accessBlackmarket,
				})	
			end
end)

-- RegisterNetEvent("lc_ilegalmkt:updateVehicles")
-- AddEventHandler("lc_ilegalmkt:updateVehicles", function()
-- 	Citizen.Wait(100)
-- 	-- vSERVER.getAds(vehAds, itemsAds, blackmarketAds, identifier)
-- 		local vehAds1 = {}

-- 		for k,v in ipairs(vehAds) do
-- 			if v.author_identifier ~= identifier and not v.sold then
-- 				table.insert(vehAds1, v)
-- 			end
-- 		end

-- 		SendNUIMessage({
-- 			action = 'updateVehicles',
-- 			vehAds = vehAds1,
-- 		})	
-- end)

RegisterNetEvent("lc_ilegalmkt:updateItems")
AddEventHandler("lc_ilegalmkt:updateItems", function()
	Citizen.Wait(100)
	-- local adsvar = vSERVER.getAds(vehAds, itemsAds, blackmarketAds, identifier)
	-- local ads = vSERVER.getAds(vehAds, itemsAds, blackmarketAds, identifier)

		-- local GetItemAds = vSERVER.getItemAds()




		local itemsAds = vSERVER.getItemAds()


		local identifier = vSERVER.getIdentifer()

		local itemsAds1 = {}





	-- print(ads[2])

		-- print(json.encode(adsvar))
		-- print(adsvar[2])

		for k,v in ipairs(itemsAds) do
			if v.author_identifier ~= identifier and not v.sold then
				table.insert(itemsAds1, v)
			end
		end

		SendNUIMessage({
			action = 'updateItems',
			itemsAds = itemsAds1,
		})	
end)

-- RegisterNetEvent("lc_ilegalmkt:updateBlackmarket")
-- AddEventHandler("lc_ilegalmkt:updateBlackmarket", function()
-- 	Citizen.Wait(100)
-- 	-- vSERVER.getAds(vehAds, itemsAds, blackmarketAds, identifier)
-- 		local blackmarketAds1 = {}

-- 		for k,v in ipairs(blackmarketAds) do
-- 			if v.author_identifier ~= identifier and not v.sold then
-- 				table.insert(blackmarketAds1, v)
-- 			end
-- 		end

-- 		SendNUIMessage({
-- 			action = 'updateBlackmarket',
-- 			blackmarketAds = blackmarketAds1,
-- 		})	
-- end)

RegisterNetEvent("lc_ilegalmkt:updateMyAds")
AddEventHandler("lc_ilegalmkt:updateMyAds", function()
	-- print('chegou aq')
	Citizen.Wait(100)
	-- vSERVER.getAds(vehAds, itemsAds, blackmarketAds, identifier)
		local myAds = {}


		local itemsAds = vSERVER.getItemAds()


		local identifier = vSERVER.getIdentifer()

		-- for k,v in ipairs(vehAds) do
		-- 	if v.author_identifier == identifier then
		-- 		table.insert(myAds, v)
		-- 	end
		-- end

		for k,v in ipairs(itemsAds) do
			if v.author_identifier == identifier then
				table.insert(myAds, v)
			end
		end

		-- for k,v in ipairs(blackmarketAds) do
		-- 	if v.author_identifier == identifier then
		-- 		table.insert(myAds, v)
		-- 	end
		-- end

		SendNUIMessage({
			action = 'updateMyAds',
			myAds = myAds,
		})	
end)

RegisterNetEvent("lc_ilegalmkt:updateMyAdsTable")
AddEventHandler("lc_ilegalmkt:updateMyAdsTable", function()
	Citizen.Wait(100)
	-- vSERVER.getAds(vehAds, itemsAds, blackmarketAds, identifier)
		local myAds = {}

		-- for k,v in ipairs(vehAds) do
		-- 	if v.author_identifier == identifier then
		-- 		table.insert(myAds, v)
		-- 	end
		-- end


		local itemsAds = vSERVER.getItemAds()


		local identifier = vSERVER.getIdentifer()

		for k,v in ipairs(itemsAds) do
			if v.author_identifier == identifier then
				table.insert(myAds, v)
			end
		end

		-- for k,v in ipairs(blackmarketAds) do
		-- 	if v.author_identifier == identifier then
		-- 		table.insert(myAds, v)
		-- 	end
		-- end

		SendNUIMessage({
			action = 'updateMyAdsTable',
			myAds = myAds,
		})	
end)

-- RegisterNetEvent("lc_ilegalmkt:updateVehiclesDropdown")
-- AddEventHandler("lc_ilegalmkt:updateVehiclesDropdown", function()
-- 	Citizen.Wait(100)
-- 	local vehiclesTable = {}
-- 	vSERVER.getItems(items)
-- 		for k,v in ipairs(vehicles) do
-- 			local canAdd = true
-- 			for k2,v2 in ipairs(Config.BlacklistVehicles) do
-- 				if GetDisplayNameFromVehicleModel(v.vehicle.model) == v2 then
-- 					canAdd = false
-- 					break
-- 				end
-- 			end

-- 			if canAdd then
-- 				table.insert(vehiclesTable, {vehicle = v.vehicle, plate = v.plate, name = GetDisplayNameFromVehicleModel(v.vehicle.model)})
-- 			end
-- 		end
-- 		SendNUIMessage({
-- 			action = 'updateVehiclesDropdown',
-- 			vehicles = vehiclesTable,
-- 		})
-- end)


RegisterNetEvent("lc_ilegalmkt:closeMarket")
AddEventHandler("lc_ilegalmkt:closeMarket", function()
	-- isMarketOpen = false
	-- SetNuiFocus(false, false)
	SendNUIMessage({
		action = 'closeMenu'
	})
end)

RegisterNetEvent("lc_ilegalmkt:updateItemsDropdown")
AddEventHandler("lc_ilegalmkt:updateItemsDropdown", function()
	Citizen.Wait(100)
	local itemsTable = {}
	local items = vSERVER.getItems()
		for k,v in ipairs(items) do
			local canAdd = true
			if v.amount > 0 then


				for k2,v2 in ipairs(Config.BlacklistItems) do
					if v.item == v2 then
						canAdd = false
						break
					end
				end

				if canAdd then
					table.insert(itemsTable, {id = v.item, label = vSERVER.getItemInfos(v.item), count = vSERVER.getItemParseVal(v.amount)})
				end
			end
		end

		SendNUIMessage({
			action = 'updateItemsDropdown',
			items = itemsTable,
		})
end)

-- RegisterNetEvent("lc_ilegalmkt:updateBlackmarketDropdown")
-- AddEventHandler("lc_ilegalmkt:updateBlackmarketDropdown", function()
-- 	Citizen.Wait(100)
-- 	local blackmarketTable = {}
-- 	vSERVER.getItems(items)
-- 		for k,v in ipairs(items) do
-- 			local canAdd = true
-- 			local blackmarketItem = false
-- 			if v.count > 0 then
-- 				for k2,v2 in ipairs(Config.BlacklistItems) do
-- 					if v.name == v2 then
-- 						canAdd = false
-- 						break
-- 					end
-- 				end

-- 				if not canAdd then
-- 					for k2,v2 in ipairs(Config.Blackmarket) do
-- 						if v.name == v2[1] and not v2[2] then
-- 							blackmarketItem = true
-- 							break
-- 						end
-- 					end

-- 					if blackmarketItem then
-- 						table.insert(blackmarketTable, {id = v.name, label = v.label, count = v.count, type = "item"})
-- 					end
-- 				end
-- 			end
-- 		end

		-- for k,v in ipairs(loadout) do
		-- 	for k2,v2 in ipairs(Config.Blackmarket) do
		-- 		if v.name == v2[1] and v2[2] then
		-- 			table.insert(blackmarketTable, {id = v.name, label = v.label, count = 1, type = "weapon"})
		-- 		end
		-- 	end
		-- end
-- 		SendNUIMessage({
-- 			action = 'updateBlackmarketDropdown',
-- 			blackmarket = blackmarketTable,
-- 		})
-- end)

RegisterNUICallback("action", function(data, cb)
	-- print(data)
	local phone = vSERVER.getPhone(phone)
	if data.action == "close" then
		isMarketOpen = false
		SetNuiFocus(false, false)
	elseif data.action == "placeAd" then
		if data.window == "vehicles" then
			-- vSERVER.getPhone(phone)
			-- 	if data.desc == "" then
			-- 		local desc = "Nothing to add"
			-- 		TSE('lc_ilegalmkt:addVehicle', data.item, data.price, desc, phone)
			-- 	else
			-- 		TSE('lc_ilegalmkt:addVehicle', data.item, data.price, data.desc, phone)
			-- 	end
		elseif data.window == "items" then
			-- print('aq')
			-- vSERVER.getPhone(phone)
				if data.desc == "" then
					local desc = "Nothing to add"
					TSE('lc_ilegalmkt:addItem', data.item, tonumber(data.amount), data.price, desc, phone)
				else
					TSE('lc_ilegalmkt:addItem', data.item, tonumber(data.amount), data.price, data.desc, phone)
				end
		elseif data.window == "blackmarket" then
			-- vSERVER.getPhone(phone)
				-- if data.desc == "" then
				-- 	local desc = "Nothing to add"
				-- 	TSE('lc_ilegalmkt:addBlackmarket', data.item, data.price, desc, phone, tonumber(data.amount))
				-- else
				-- 	TSE('lc_ilegalmkt:addBlackmarket', data.item, data.price, data.desc, phone, tonumber(data.amount))
				-- end
		end
	elseif data.action == "missing" then
		TriggerEvent("Notify", "amarelo", "Por favor, preencha todos os campos obrigatórios", 5000)
	elseif data.action == "missingSearch" then
		TriggerEvent("Notify", "amarelo", "Preencha os campos corretamente", 5000)
	elseif data.action == "high" then
		TriggerEvent("Notify", "amarelo", "Você não tem itens suficientes para vender", 5000)
	elseif data.action == "buyVehicle" then
		-- ESX.TriggerServerCallback("lc_ilegalmkt:getVehicle", function(veh)
		-- 	TSE('lc_ilegalmkt:buyVehicle', veh)
		-- end, data.id)
	elseif data.action == "buyItem" then
		-- vSERVER.getItem(item)
		-- data.id, data.item
			-- print(data.id, data.item)
			-- print(data.price)
			-- print(data.amount)
			-- print(data.target)
			TSE('lc_ilegalmkt:buyItem', data.id, data.item, data.price, data.amount, data.target)
	elseif data.action == "buyBlackmarket" then
		-- ESX.TriggerServerCallback("lc_ilegalmkt:getBlackmarket", function(blackmarket)
		-- 	TSE('lc_ilegalmkt:buyBlackmarket', blackmarket)
		-- end, data.id, data.blackmarket)
	elseif data.action == "myAd" then
		-- print('my adddd')
		TSE('lc_ilegalmkt:removeMyAd', data.item)
	elseif data.action == "refresh" then
		if data.window == "vehicles" then
			-- TriggerEvent('lc_ilegalmkt:updateVehicles')
		elseif data.window == "items" then
			TriggerEvent('lc_ilegalmkt:updateItems')
		elseif data.window == "blackmarket" then
			-- TriggerEvent('lc_ilegalmkt:updateBlackmarket')
		end
	end
end)