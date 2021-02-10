local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local Tools = module("vrp","lib/Tools")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

--[ CONNECTION ]----------------------------------------------------------------------------------------------------------------

pEP = {}
Tunnel.bindInterface("ldn-energetic-production",pEP)

local idgens = Tools.newIDGenerator()

--[ VARIABLES ]-----------------------------------------------------------------------------------------------------------------

local blips = {}
local ammount = {}

--[ DELIVERY ORDER | FUNCTION (CHECK PERMISSION) ]-------------------------------------------------------------------------------------------------

function pEP.checkPermission()
  local source = source
  local user_id = vRP.getUserId(source)
  return not (vRP.hasPermission(user_id,"policia.permissao") or vRP.hasPermission(user_id,"paramedico.permissao"))
end

--[ DELIVERY ORDER | FUNCTION (START PAYMENTS) ]-------------------------------------------------------------------------------------------------

function pEP.startPayments()
  local source = source
  local user_id = vRP.getUserId(source)
  local ped = GetPlayerPed(source)
  if ammount[source] == nil then
    ammount[source] = math.random(1,3)
  end
	if user_id then
		TriggerClientEvent("progress",source,2000,"Produção | Coletando alguns energéticos")
		FreezeEntityPosition(ped, true)
		vRPclient._playAnim(source,false,{{"timetable@jimmy@doorknock@","knockdoor_idle"}},true)

		Citizen.Wait(2000)
		vRPclient._stopAnim(source,false)
		FreezeEntityPosition(ped, false)

    vRP.giveInventoryItem(user_id,"energetico",ammount[source])
    TriggerClientEvent("Notify",source,"sucesso","Você recebeu <b>x"..ammount[source].." energético(s)</b>.")
		ammount[source] = nil
    return true
	end
end