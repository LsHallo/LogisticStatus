require("mod-gui")

SPRITE_NONE = "robo-x"
SPRITE_CONSTRUCTION = "robo-con"
SPRITE_LOGISTIC = "robo-log"

icon = nil
is_first = true


function load()
	local player = game.players[1]

	local buttonflow = mod_gui.get_button_flow(player)
	icon = buttonflow.LogisticIndicator or buttonflow.add {
		type = "sprite-button",
		name = "LogisticIndicator",
		sprite = SPRITE_NONE
	}
end

script.on_nth_tick(15,
	function (e)
		if is_first then
			load()
			is_first = false
		end

		hasrun = false
		local p = game.players[1]
			local network = game.surfaces[1].find_logistic_networks_by_construction_area(p.position, p.force)
			if network ~= nil then
				for k,v in pairs(network) do
					local cell = v.find_cell_closest_to(p.position)
					if cell.logistic_radius > 0 then
						hasrun = true
						if cell.is_in_logistic_range(p.position) then
							has_construction = true
							has_logistic = true
							print "in logistic range"
						elseif cell.is_in_construction_range(p.position) then
							has_construction = true
							has_logistic = false
							print "in construction range"
						else
							has_construction = false
							has_logistic = false
							print "not in roboport range 1"
						end
					end
				end
			else
				has_construction = false
				has_logistic = false
				print "not in roboport range 2"
			end
			if hasrun ~= true then
				has_construction = false
				has_logistic = false
				print "not in range hasn't run"
			end

		if has_construction then
			if has_logistic then
				icon.sprite = SPRITE_LOGISTIC
			else
				icon.sprite = SPRITE_CONSTRUCTION
			end
		else
			icon.sprite = SPRITE_NONE
		end
	end
)
