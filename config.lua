Config = {}

-------------------
-- false = use command to open the market | true = use blips to open the market
Config.UseBlipToAccessMarket = true

-- If false:
-- This will let the player open the market anywhere
Config.MarketCommand = "market" -- Command to open the market

-- If true:
Config.OpenMarketKey = 38 -- [E] Key to open the interaction, check here the keys ID: https://docs.fivem.net/docs/game-references/controls/#controls

Config.ShowFloorBlips = true -- If true it'll show the crafting markers on the floor

Config.UseOkokTextUI = false -- true = okokTextUI (I recommend you using this since it is way more optimized than the default ShowHelpNotification) | false = ShowHelpNotification

Config.ShowBlipsOnMap = false -- Will show the blips on the map (if true it'll use the blipId, blipColor, blipScale and blipText to create them)

Config.BlipCoords = { 
	--{x = 887.38, y = -953.76, z = 39.22, radius = 5, blipId = 78, blipColor = 3, blipScale = 0.9, blipText = "Marketplace", showMarkerRadius = 50, MarkerID = 29},
}  

Config.BlacklistItems = { 
	"dinheirosujo",
	"celular",
}

-------------------------- DISCORD LOGS

Config.BotName = 'ServerName' -- Write the desired bot name

Config.ServerName = 'ServerName' -- Write your server's name

Config.IconURL = '' -- Insert your desired image link

Config.DateFormat = '%d/%m/%Y [%X]' -- To change the date format check this website - https://www.lua.org/pil/22.1.html

-- To change a webhook color you need to set the decimal value of a color, you can use this website to do that - https://www.mathsisfun.com/hexadecimal-decimal-colors.html

Config.AddAdColor = '6225733'

Config.BuyItemColor = '224'

Config.RemoveAdColor = '16711680'

Config.ClaimAdColor = '12231480'