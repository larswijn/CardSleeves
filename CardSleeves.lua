--- STEAMODDED HEADER
--- MOD_NAME: Card Sleeves
--- MOD_ID: CardSleeves
--- MOD_AUTHOR: [LarsWijn]
--- MOD_DESCRIPTION: Adds sleeves as modifier to decks.
--- PREFIX: casl
--- LOADER_VERSION_GEQ: 1.0.0

----------------------------------------------
------------MOD CODE -------------------------

local function print_trace(...)
    return sendTraceMessage(table.concat({ ... }, "\t"), "CardSleeves")
end

local function print_debug(...)
    return sendDebugMessage(table.concat({ ... }, "\t"), "CardSleeves")
end

local function print_info(...)
    return sendInfoMessage(table.concat({ ... }, "\t"), "CardSleeves")
end

local function print_warning(...)
    return sendWarnMessage(table.concat({ ... }, "\t"), "CardSleeves")
end

local function tprint(tbl, indent)
    if tbl == nil then return "nil" end
    if not indent then indent = 0 end
    local toprint = string.rep(" ", indent) .. "{\r\n"
    indent = indent + 2
    for k, v in pairs(tbl) do
        toprint = toprint .. string.rep(" ", indent)
        if (type(k) == "number") then
            toprint = toprint .. "[" .. k .. "] = "
        elseif (type(k) == "string") then
            toprint = toprint .. k .. "= "
        end
        if (type(v) == "number") then
            toprint = toprint .. v .. ",\r\n"
        elseif (type(v) == "string") then
            if k == "content" then
                toprint = toprint .. "...,\r\n"
            else
                toprint = toprint .. "\"" .. v .. "\",\r\n"
            end
        elseif (type(v) == "table") then
            if indent >= 10 then
                toprint = toprint .. tostring(v) .. ",\r\n"
            else
                toprint = toprint .. tostring(v) .. tprint(v, indent + 1) .. ",\r\n"
            end
        else
            toprint = toprint .. "\"" .. tostring(v) .. "\",\r\n"
        end
    end
    toprint = toprint .. string.rep(" ", indent - 2) .. "}"
    return toprint
end

function SMODS.current_mod.process_loc_text()
    G.localization.descriptions.Sleeve = G.localization.descriptions.Sleeve or {}
    G.localization.descriptions.Sleeve["v_crystal_ball"] = { text = { "v_crystal_ball" } }
    G.localization.descriptions.Sleeve["c_fool"] = { text = { "c_fool" } }
end

SMODS.Atlas {
    key = "sleeve_atlas",
    path = "sleeves.png", -- only contains blue sleeve for now
    px = 71,
    py = 95
}

SMODS.Sleeves = {}
SMODS.Sleeve = SMODS.GameObject:extend {
    obj_table = SMODS.Sleeves,
    obj_buffer = {},
    class_prefix = "sleeve",
    discovered = false,
    unlocked = true,
    set = "Sleeve",
    atlas = "sleeve_atlas",
    pos = { x = 0, y = 0 }, -- within `atlas`
    required_params = { "key", "pos" },
    inject_class = function(self)
        G.P_CENTER_POOLS[self.set] = {}
        G.P_SLEEVES = {}
        self.super.inject_class(self)
    end,
    inject = function(self)
        G.P_SLEEVES[self.key] = self
        SMODS.insert_pool(G.P_CENTER_POOLS[self.set], self)
    end,
    loc_vars = function() return { vars = {} } end
}

SMODS.Sleeve {
    key = "none",
    name = "No Sleeve",
    config = {},
    loc_txt = {
        name = "No Sleeve",
        text = { "No extra deck modifiers" }
    },
    atlas = "jokers",
    pos = { x = 9, y = 0 }
}

SMODS.Sleeve {
    key = "red",
    name = "Red Sleeve",
    config = { discards = 1 },
    loc_txt = {
        name = "Red Sleeve",
        text = G.localization.descriptions.Back["b_red"].text
    },
    loc_vars = function(self)
        return { vars = { self.config.discards } }
    end,
    pos = { x = 0, y = 0 }
}

SMODS.Sleeve {
    key = "blue",
    name = "Blue Sleeve",
    config = { hands = 1 },
    loc_txt = {
        name = "Blue Sleeve",
        text = G.localization.descriptions.Back["b_blue"].text
    },
    loc_vars = function(self)
        return { vars = { self.config.hands } }
    end,
    atlas = "sleeve_atlas",
    pos = { x = 0, y = 1 }
}

SMODS.Sleeve {
    key = "yellow",
    name = "Yellow Sleeve",
    config = { dollars = 10 },
    loc_txt = {
        name = "Yellow Sleeve",
        text = G.localization.descriptions.Back["b_yellow"].text
    },
    loc_vars = function(self)
        return { vars = { self.config.dollars } }
    end,
    atlas = "sleeve_atlas",
    pos = { x = 0, y = 2 }
}

SMODS.Sleeve {
    key = "green",
    name = "Green Sleeve",
    config = { extra_hand_bonus = 2, extra_discard_bonus = 1, no_interest = true },
    loc_txt = {
        name = "Green Sleeve",
        text = G.localization.descriptions.Back["b_green"].text
    },
    loc_vars = function(self)
        return { vars = { self.config.extra_hand_bonus, self.config.extra_discard_bonus, self.config.no_interest } }
    end,
    atlas = "sleeve_atlas",
    pos = { x = 0, y = 3 }
}

SMODS.Sleeve {
    key = "black",
    name = "Black Sleeve",
    config = { hands = -1, joker_slot = 1 },
    loc_txt = {
        name = "Black Sleeve",
        text = G.localization.descriptions.Back["b_black"].text
    },
    loc_vars = function(self)
        return { vars = { self.config.joker_slot, self.config.hands } }
    end,
    atlas = "sleeve_atlas",
    pos = { x = 0, y = 4 }
}

SMODS.Sleeve {
    key = "magic",
    name = "Magic Sleeve",
    config = { voucher = 'v_crystal_ball', consumables = { 'c_fool', 'c_fool' } },
    loc_txt = {
        name = "Magic Sleeve",
        text = G.localization.descriptions.Back["b_magic"].text
    },
    loc_vars = function(self)
        return { vars = { self.config.voucher, self.config.consumables } }
    end,
    atlas = "sleeve_atlas",
    pos = { x = 1, y = 0 }
}

SMODS.Sleeve {
    key = "nebula",
    name = "Nebula Sleeve",
    config = { voucher = 'v_telescope', consumable_slot = -1 },
    loc_txt = {
        name = "Nebula Sleeve",
        text = G.localization.descriptions.Back["b_nebula"].text
    },
    loc_vars = function(self)
        return { vars = { self.config.voucher, self.config.consumable_slot } }
    end,
    atlas = "sleeve_atlas",
    pos = { x = 1, y = 1 }
}

SMODS.Sleeve {
    key = "ghost",
    name = "Ghost Sleeve",
    config = { spectral_rate = 2, consumables = { 'c_hex' } },
    loc_txt = {
        name = "Nebula Sleeve",
        text = G.localization.descriptions.Back["b_ghost"].text
    },
    loc_vars = function(self)
        return { vars = { self.config.spectral_rate, self.config.consumables } }
    end,
    atlas = "sleeve_atlas",
    pos = { x = 1, y = 2 }
}

SMODS.Sleeve {
    key = "abandoned",
    name = "Abandoned Sleeve",
    config = { remove_faces = true },
    loc_txt = {
        name = "Abandoned Sleeve",
        text = G.localization.descriptions.Back["b_abandoned"].text
    },
    loc_vars = function(self)
        return { vars = { self.config.remove_faces } }
    end,
    atlas = "sleeve_atlas",
    pos = { x = 1, y = 3 }
}

SMODS.Sleeve {
    key = "checkered",
    name = "Checkered Sleeve",
    config = {},
    loc_txt = {
        name = "Checkered Sleeve",
        text = G.localization.descriptions.Back["b_checkered"].text
    },
    loc_vars = function(self)
        return { vars = {} }
    end,
    atlas = "sleeve_atlas",
    pos = { x = 1, y = 4 }
}




G.FUNCS.change_sleeve = function(args)
    G.viewed_sleeve = args.to_key
    G.PROFILES[G.SETTINGS.profile].MEMORY.sleeve = args.to_key
end

G.FUNCS.RUN_SETUP_check_sleeve = function(e)
    if (G.GAME.viewed_back.name ~= e.config.id) then
        e.config.object:remove()
        e.config.object = UIBox {
            definition = G.UIDEF.sleeve_option(G.SETTINGS.current_setup),
            config = { offset = { x = 0, y = 0 }, align = 'tmi', parent = e }
        }
        e.config.id = G.GAME.viewed_back.name
    end
end

G.FUNCS.RUN_SETUP_check_sleeve2 = function(e)
    if (G.viewed_sleeve ~= e.config.id) then
        e.config.object:remove()
        e.config.object = UIBox {
            definition = G.UIDEF.viewed_sleeve_option(),
            config = { offset = { x = 0, y = 0 }, align = 'cm', parent = e }
        }
        e.config.id = G.viewed_sleeve
    end
end

function G.UIDEF.sleeve_description(_sleeve)
    print_trace("func sleeve_description")
    local _sleeve_center = G.P_CENTER_POOLS.Sleeve[_sleeve]
    local ret_nodes = {}
    if _sleeve_center then
        localize { type = 'descriptions',
            key = _sleeve_center.key,
            set = _sleeve_center.set,
            vars = _sleeve_center:loc_vars().vars,
            nodes = ret_nodes }
    end

    local desc_t = {}
    for k, v in ipairs(ret_nodes) do
        for k2, v2 in pairs(v) do
            if v2["config"] ~= nil and v2["config"]["scale"] ~= nil then
                v[k2]["config"].scale = v[k2]["config"].scale / 1.25
            end
        end
        desc_t[#desc_t + 1] = { n = G.UIT.R, config = { align = "cm", maxw = 5.3 }, nodes = v }
    end

    return {
        n = G.UIT.C,
        config = { align = "cm", padding = 0.05, r = 0.1, colour = G.C.L_BLACK },
        nodes = {
            {
                n = G.UIT.R,
                config = { align = "cm", padding = 0 },
                nodes = {
                    { n = G.UIT.T, config = { text = localize { type = 'name_text', key = _sleeve_center.key, set = _sleeve_center.set }, scale = 0.35, colour = G.C.WHITE } }
                }
            },
            { n = G.UIT.R, config = { align = "cm", padding = 0.03, colour = G.C.WHITE, r = 0.1, minh = 1, minw = 5.5 }, nodes = desc_t }
        }
    }
end

function G.UIDEF.sleeve_option(_type)
    local middle = {
        n = G.UIT.R,
        config = { align = "cm", minh = 1.7, minw = 7.3 },
        nodes = {
            { n = G.UIT.O, config = { id = nil, func = 'RUN_SETUP_check_sleeve2', object = Moveable() } },
        }
    }
    local sleeve_options = {}
    for _, v in pairs(SMODS.Sleeves) do
        if v.unlocked then
            table.insert(sleeve_options, v)
        end
    end

    return {
        n = G.UIT.ROOT,
        config = { align = "tm", colour = G.C.CLEAR, minw = 8.5 },
        nodes = { _type == 'Continue' and middle or create_option_cycle({
            options =
                sleeve_options,
            opt_callback = 'change_sleeve',
            current_option = G.viewed_sleeve,
            colour = G.C.RED,
            w = 6,
            mid = middle
        }) }
    }
end

function G.UIDEF.viewed_sleeve_option()
    G.viewed_sleeve = G.viewed_sleeve or 1
    -- where is `_type` even defined??
    if _type ~= 'Continue' then G.PROFILES[G.SETTINGS.profile].MEMORY.sleeve = G.viewed_sleeve end

    -- TODO: update visual sleeve around cards?

    return {
        n = G.UIT.ROOT,
        config = { align = "cm", colour = G.C.BLACK, r = 0.1, minw = 7.23 },
        nodes = {
            {
                n = G.UIT.C,
                config = { align = "cm", padding = 0 },
                nodes = {
                    { n = G.UIT.T, config = { text = "Sleeve", scale = 0.4, colour = G.C.L_BLACK } }
                }
            },
            {
                n = G.UIT.C,
                config = { align = "cm", padding = 0.1 },
                nodes = {
                    G.UIDEF.sleeve_description(G.viewed_sleeve)
                }
            }
        }
    }
end

function dump(o, depth)
    depth = depth or 0
    if depth > 14 then
        return "..."
    elseif type(o) == 'table' then
        local s = '{ '
        for k, v in pairs(o) do
            if type(k) ~= 'number' then k = '"' .. k .. '"' end
            s = s .. k .. ': ' .. dump(v, depth + 1) .. ','
        end
        return s .. '} '
    else
        return tostring(o)
    end
end

local old_run_setup_option = G.UIDEF.run_setup_option
function G.UIDEF.run_setup_option(_type)
    -- wrap `run_setup_option` with our own func
    local output = old_run_setup_option(_type)
    -- print_trace("func run_setup_option")
    --[[
    nodes =
    [
        RUN_SETUP_check_back, RUN_SETUP_check_bake_stake_column,
        RUN_SETUP_check_stake=
        [
            stake_object
        ],
        toggle_seeded_run,
        [input_seed, button_play]
    ]
    --]]
    print(dump(output))
    if _type == "Continue" then
        table.insert(output.nodes, 3,
            {
                n = G.UIT.R,
                config = { align = "cm" },
                nodes = {
                    {
                        n = G.UIT.T,
                        config = { text = "Text", colour = G.C.UI.TEXT_LIGHT, scale = 0.4 }
                    }
                }
            })
    elseif _type == "New Run" then
        table.insert(output.nodes, 3,
            {
                n = G.UIT.R,
                config = { align = "cm", minh = 1.65, minw = 6.8 },
                nodes = {
                    {
                        n = G.UIT.O,
                        config = { id = nil, func = 'RUN_SETUP_check_sleeve', insta_func = true, object = Moveable() }
                    }
                }
            })
    end
    return output
end

local old_RUN_SETUP_check_back = G.FUNCS.RUN_SETUP_check_back
function G.FUNCS.RUN_SETUP_check_back(e)
    if G.GAME.viewed_back.name ~= e.config.id then
        -- print_debug("Deck change! current deck is " .. G.GAME.viewed_back.name .. "!")
    end
    return old_RUN_SETUP_check_back(e)
end

----------------------------------------------
------------MOD CODE END----------------------
