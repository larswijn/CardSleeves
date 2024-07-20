--- STEAMODDED HEADER
--- MOD_NAME: Card Sleeves
--- MOD_ID: CardSleeves
--- MOD_AUTHOR: [LarsWijn]
--- MOD_DESCRIPTION: Adds sleeves as modifier to decks, similar to stakes.
--- PREFIX: casl
--- LOADER_VERSION_GEQ: 1.0.0

----------------------------------------------
------------MOD CODE -------------------------

--[[

ISSUES:

* sleeves cannot be dragged around during deck select like the current top card of the deck can
    - this is a fix to another bug that doesn't "reset" the sleeve back to it's original position after moving it

--]]

-- DEBUG FUNCS (can remove on release?)

G.DEBUG = true
_RELEASE_MODE = false

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
            if indent >= 3 then
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

-- LOCALIZATION

function SMODS.current_mod.process_loc_text()
    G.localization.descriptions.Sleeve = G.localization.descriptions.Sleeve or {}
end

-- ATLAS

SMODS.Atlas {
    key = "sleeve_atlas",
    path = "sleeves.png", -- only contains first 5 sleeves for now
    px = 71,
    py = 95
}

-- SLEEVE BASE CLASS & METHODS

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
    required_params = { "key", "pos"},
    inject_class = function(self)
        G.P_CENTER_POOLS[self.set] = {}
        G.P_SLEEVES = {}
        self.super.inject_class(self)
    end,
    inject = function(self)
        G.P_SLEEVES[self.key] = self
        SMODS.insert_pool(G.P_CENTER_POOLS[self.set], self)
    end,
    loc_vars = function() return { vars = {} } end,
    generate_UI = function(self)
        min_dims = min_dims or 0.7
        loc_nodes = {}
        return {n=G.UIT.ROOT, config={align = "cm", minw = min_dims*5, minh = min_dims*2.5, id = self.name, colour = G.C.CLEAR}, nodes={
            desc_from_rows(loc_nodes, true, min_dims*5)
        }}
    end
}

function SMODS.Sleeve:apply_to_run()
    print_trace("Sleeve.apply_to_run")

    if self.config.voucher then
        G.GAME.used_vouchers[self.config.voucher] = true
        G.GAME.starting_voucher_count = (G.GAME.starting_voucher_count or 0) + 1
        Card.apply_to_run(nil, G.P_CENTERS[self.config.voucher])
    end
    if self.config.hands then
        G.GAME.starting_params.hands = G.GAME.starting_params.hands + self.config.hands
    end
    if self.config.consumables then
        delay(0.4)
        G.E_MANAGER:add_event(Event({
            func = function()
                for k, v in ipairs(self.config.consumables) do
                    local card = create_card('Tarot', G.consumeables, nil, nil, nil, nil, v, 'deck')
                    card:add_to_deck()
                    G.consumeables:emplace(card)
                end
                return true
            end
        }))
    end

    if self.config.dollars then
        G.GAME.starting_params.dollars = G.GAME.starting_params.dollars + self.config.dollars
    end
    if self.config.remove_faces then
        G.GAME.starting_params.no_faces = true
    end

    if self.config.spectral_rate then
        G.GAME.spectral_rate = self.config.spectral_rate
    end
    if self.config.discards then
        G.GAME.starting_params.discards = G.GAME.starting_params.discards + self.config.discards
    end
    if self.config.reroll_discount then
        G.GAME.starting_params.reroll_cost = G.GAME.starting_params.reroll_cost - self.config.reroll_discount
    end

    if self.config.edition then
        G.E_MANAGER:add_event(Event({
            func = function()
                local i = 0
                while i < self.config.edition_count do
                    local card = pseudorandom_element(G.playing_cards, pseudoseed('edition_deck'))
                    if not card.edition then
                        i = i + 1
                        card:set_edition({ [self.config.edition] = true }, nil, true)
                    end
                end
                return true
            end
        }))
    end
    if self.config.vouchers then
        for k, v in pairs(self.config.vouchers) do
            G.GAME.used_vouchers[v] = true
            G.GAME.starting_voucher_count = (G.GAME.starting_voucher_count or 0) + 1
            Card.apply_to_run(nil, G.P_CENTERS[v])
        end
    end
    if self.name == 'Checkered Sleeve' then
        G.E_MANAGER:add_event(Event({
            func = function()
                for k, v in pairs(G.playing_cards) do
                    if v.base.suit == 'Clubs' then
                        v:change_suit('Spades')
                    end
                    if v.base.suit == 'Diamonds' then
                        v:change_suit('Hearts')
                    end
                end
                return true
            end
        }))
    end
    if self.config.randomize_rank_suit then
        G.GAME.starting_params.erratic_suits_and_ranks = true
    end
    if self.config.joker_slot then
        G.GAME.starting_params.joker_slots = G.GAME.starting_params.joker_slots + self.config.joker_slot
    end
    if self.config.hand_size then
        G.GAME.starting_params.hand_size = G.GAME.starting_params.hand_size + self.config.hand_size
    end
    if self.config.ante_scaling then
        G.GAME.starting_params.ante_scaling = self.config.ante_scaling
    end
    if self.config.consumable_slot then
        G.GAME.starting_params.consumable_slots = G.GAME.starting_params.consumable_slots + self.config.consumable_slot
    end
    if self.config.no_interest then
        G.GAME.modifiers.no_interest = true
    end
    if self.config.extra_hand_bonus then
        G.GAME.modifiers.money_per_hand = self.config.extra_hand_bonus
    end
    if self.config.extra_discard_bonus then
        G.GAME.modifiers.money_per_discard = self.config.extra_discard_bonus
    end
end

function SMODS.Sleeve:trigger_effect(args)
    print_trace("Sleeve.trigger_effect")
    if not args then return end
    
    if self.name == 'Anaglyph Sleeve' and args.context == 'eval' and G.GAME.last_blind and G.GAME.last_blind.boss then
        G.E_MANAGER:add_event(Event({
            func = (function()
                add_tag(Tag('tag_double'))
                play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
                play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
                return true
            end)
        }))
    end
    if self.name == 'Plasma Sleeve' and args.context == 'blind_amount' then
        return 
    end

    if self.name == 'Plasma Sleeve' and args.context == 'final_scoring_step' then
        local tot = args.chips + args.mult
        args.chips = math.floor(tot/2)
        args.mult = math.floor(tot/2)
        update_hand_text({delay = 0}, {mult = args.mult, chips = args.chips})

        G.E_MANAGER:add_event(Event({
            func = (function()
                local text = localize('k_balanced')
                play_sound('gong', 0.94, 0.3)
                play_sound('gong', 0.94*1.5, 0.2)
                play_sound('tarot1', 1.5)
                ease_colour(G.C.UI_CHIPS, {0.8, 0.45, 0.85, 1})
                ease_colour(G.C.UI_MULT, {0.8, 0.45, 0.85, 1})
                attention_text({
                    scale = 1.4, text = text, hold = 2, align = 'cm', offset = {x = 0,y = -2.7},major = G.play
                })
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    blockable = false,
                    blocking = false,
                    delay =  4.3,
                    func = (function() 
                            ease_colour(G.C.UI_CHIPS, G.C.BLUE, 2)
                            ease_colour(G.C.UI_MULT, G.C.RED, 2)
                        return true
                    end)
                }))
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    blockable = false,
                    blocking = false,
                    no_delete = true,
                    delay =  6.3,
                    func = (function() 
                        G.C.UI_CHIPS[1], G.C.UI_CHIPS[2], G.C.UI_CHIPS[3], G.C.UI_CHIPS[4] = G.C.BLUE[1], G.C.BLUE[2], G.C.BLUE[3], G.C.BLUE[4]
                        G.C.UI_MULT[1], G.C.UI_MULT[2], G.C.UI_MULT[3], G.C.UI_MULT[4] = G.C.RED[1], G.C.RED[2], G.C.RED[3], G.C.RED[4]
                        return true
                    end)
                }))
                return true
            end)
        }))

        delay(0.6)
        return args.chips, args.mult
    end
end

-- SLEEVE INSTANCES

SMODS.Sleeve {
    key = "none",
    name = "No Sleeve",
    config = {},
    loc_txt = {
        name = "No Sleeve",
        text = { "No sleeve modifiers" }
    },
    atlas = "sleeve_atlas",
    pos = { x = 0, y = 3 }
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
    atlas = "sleeve_atlas",
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
    pos = { x = 1, y = 0 }
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
    pos = { x = 2, y = 0 }
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
    pos = { x = 3, y = 0 }
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
        return { vars = { self.config.joker_slot, -self.config.hands } }
    end,
    atlas = "sleeve_atlas",
    pos = { x = 4, y = 0 }
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
        return {
            vars = { localize { type = 'name_text', key = self.config.voucher, set = 'Voucher' },
                localize { type = 'name_text', key = self.config.consumables[1], set = 'Tarot' } }
        }
    end,
    atlas = "sleeve_atlas",
    pos = { x = 0, y = 1 }
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
        return {
            vars = { localize { type = 'name_text', key = self.config.voucher, set = 'Voucher' },
                self.config.consumable_slot }
        }
    end,
    atlas = "sleeve_atlas",
    pos = { x = 1, y = 1 }
}

SMODS.Sleeve {
    key = "ghost",
    name = "Ghost Sleeve",
    config = { spectral_rate = 2, consumables = { 'c_hex' } },
    loc_txt = {
        name = "Ghost Sleeve",
        text = G.localization.descriptions.Back["b_ghost"].text
    },
    loc_vars = function(self)
        return { vars = { self.config.spectral_rate, self.config.consumables } }
    end,
    atlas = "sleeve_atlas",
    pos = { x = 2, y = 1 }
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
    pos = { x = 3, y = 1 }
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
    pos = { x = 4, y = 1 }
}

SMODS.Sleeve {
    key = "zodiac",
    name = "Zodiac Sleeve",
    config = {vouchers = {'v_tarot_merchant', 'v_planet_merchant', 'v_overstock_norm'}},
    loc_txt = {
        name = "Zodiac Sleeve",
        text = G.localization.descriptions.Back["b_zodiac"].text
    },
    loc_vars = function(self)
        local vars = {}
        for _, voucher in pairs(self.config.vouchers) do
            vars[#vars+1] = localize { type = 'name_text', key = voucher, set = 'Voucher' }
        end
        return { vars = vars }
    end,
    atlas = "sleeve_atlas",
    pos = { x = 0, y = 2 }
}

SMODS.Sleeve {
    key = "painted",
    name = "Painted Sleeve",
    config = {hand_size = 2, joker_slot = -1},
    loc_txt = {
        name = "Painted Sleeve",
        text = G.localization.descriptions.Back["b_painted"].text
    },
    loc_vars = function(self)
        return { vars = { self.config.hand_size, self.config.joker_slot } }
    end,
    atlas = "sleeve_atlas",
    pos = { x = 1, y = 2 }
}

SMODS.Sleeve {
    key = "anaglyph",
    name = "Anaglyph Sleeve",
    config = {},
    loc_txt = {
        name = "Anaglyph Sleeve",
        text = G.localization.descriptions.Back["b_anaglyph"].text
    },
    loc_vars = function(self)
        return { vars = { localize{type = 'name_text', key = 'tag_double', set = 'Tag'} } }
    end,
    atlas = "sleeve_atlas",
    pos = { x = 2, y = 2 }
}

SMODS.Sleeve {
    key = "plasma",
    name = "Plasma Sleeve",
    config = {ante_scaling = 2},
    loc_txt = {
        name = "Plasma Sleeve",
        text = G.localization.descriptions.Back["b_plasma"].text
    },
    loc_vars = function(self)
        return { vars = {self.config.ante_scaling} }
    end,
    atlas = "sleeve_atlas",
    pos = { x = 3, y = 2 }
}

SMODS.Sleeve {
    key = "erratic",
    name = "Erratic Sleeve",
    config = {randomize_rank_suit = true},
    loc_txt = {
        name = "Erratic Sleeve",
        text = G.localization.descriptions.Back["b_erratic"].text
    },
    loc_vars = function(self)
        return { vars = {} }
    end,
    atlas = "sleeve_atlas",
    pos = { x = 4, y = 2 }
}

-- UI FUNCS

local function find_sleeve_card(area)
    -- loop safeguard in case some other mod decides to modify this (which would be dumb, but we did it, so...)
    for i, v in pairs(area.cards) do
        if v.children.back.atlas["original_key"] == "sleeve_atlas" then
            return i, v
        end
    end
end

function G.FUNCS.change_sleeve(args)
    G.viewed_sleeve = args.to_key
    G.PROFILES[G.SETTINGS.profile].MEMORY.sleeve = args.to_key
end

function G.FUNCS.change_viewed_sleeve()
    local sleeve_center = G.P_CENTER_POOLS.Sleeve[G.viewed_sleeve]
    --[[
    local card = G.sticker_card
    if sleeve_center.name ~= "No Sleeve" then
        card.children.back = Sprite(card.T.x - 0.05, card.T.y + 0.3, card.T.w + 0.1, card.T.h, G.ASSET_ATLAS[sleeve_center.atlas], sleeve_center.pos)
        print_debug("  card.children.back = " .. tprint(card.children.back))
        card.states.collide.can = false
        card.states.hover.can = false
        card.states.drag.can = false
        card.states.click.can = false
    else
        card.children.back = false
        card:set_ability(card.config.center, true)
    end
    --]]
    local area = G.sticker_card.area
    local sleeve_index, sleeve_card = find_sleeve_card(area)
    if sleeve_center.name ~= "No Sleeve" then
        if sleeve_card == nil then
            local new_card = Card(G.sticker_card.T.x - 0.05, G.sticker_card.T.y + 0.3, G.sticker_card.T.w + 0.1, G.sticker_card.T.h, pseudorandom_element(G.P_CARDS), G.P_CENTERS.c_base)
            new_card.sprite_facing = 'back'
            new_card.facing = 'back'
            -- the sleeve doesn't "snap back" to the original pos, for some reason. this is a very hacky fix
            new_card.states.collide.can = false
            new_card.states.hover.can = false
            new_card.states.drag.can = false
            new_card.states.click.can = false
            new_card.children.back = Sprite(new_card.T.x, new_card.T.y, new_card.T.w, new_card.T.h, G.ASSET_ATLAS[sleeve_center.atlas], sleeve_center.pos)
            area:emplace(new_card)
        else
            sleeve_card.children.back = Sprite(sleeve_card.T.x, sleeve_card.T.y + 0.3, sleeve_card.T.w, sleeve_card.T.h, G.ASSET_ATLAS[sleeve_center.atlas], sleeve_center.pos)
        end
    elseif sleeve_center.name == "No Sleeve" and sleeve_card then
        table.remove(area.cards, sleeve_index)
    elseif sleeve_card then
        print_warning("Unexpected sleeve_card properties!")
    end
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
                v[k2]["config"].scale = v[k2]["config"].scale / 1.2
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
            options = sleeve_options,
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
    -- TODO `_type` is undefined, what to do?
    if _type ~= 'Continue' then
        G.PROFILES[G.SETTINGS.profile].MEMORY.sleeve = G.viewed_sleeve
    end

    G.FUNCS.change_viewed_sleeve()

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

-- HOOKING / WRAPPING FUNCS

local old_run_setup_option = G.UIDEF.run_setup_option
function G.UIDEF.run_setup_option(_type)
    local output = old_run_setup_option(_type)
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
    if _type == "Continue" then
        -- TODO: fix this and the saving of sleeve in general
        G.viewed_sleeve = 1
        if G.SAVED_GAME ~= nil then
            G.viewed_sleeve = saved_game.GAME.selected_sleeve or G.viewed_sleeve
        end
        table.insert(output.nodes, 3,
            {
                n = G.UIT.R,
                config = { align = "cm", padding = 0.05, minh = 1.65 },
                nodes = {
                    {n=G.UIT.O, 
                     config={id = nil, func = 'RUN_SETUP_check_sleeve', insta_func = true, object = Moveable() }
                    }
                }
            })
    elseif _type == "New Run" then
        G.viewed_sleeve = G.viewed_sleeve or 1
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

local old_game_start_run = Game.start_run
function Game:start_run(args)
    old_game_start_run(self, args)
    if G.SETTINGS.current_setup == "New Run" then
        G.GAME.selected_sleeve = G.viewed_sleeve or 1
        print_trace("Game:start_run inserted sleeve arg")
        print_debug("  G.GAME.viewed_sleeve = " .. G.GAME.selected_sleeve)
    end
end

local old_FUNCS_change_viewed_back = G.FUNCS.change_viewed_back
function G.FUNCS.change_viewed_back(args)
    print_trace("func G.FUNCS.change_viewed_back")
    local area = G.sticker_card.area
    local sleeve_index, _ = find_sleeve_card(area)
    table.remove(area.cards, sleeve_index)
    old_FUNCS_change_viewed_back(args)
    G.FUNCS.change_viewed_sleeve(args)
end

local old_Back_apply_to_run = Back.apply_to_run
function Back:apply_to_run()
    print_trace("Back:apply_to_run")
    local sleeve_center = G.P_CENTER_POOLS.Sleeve[G.GAME.selected_sleeve or 1]
    sleeve_center:apply_to_run()
    return old_Back_apply_to_run(self)
end

local old_Back_trigger_effect = Back.trigger_effect
function Back:trigger_effect(args)
    print_trace("Back:trigger_effect")
    local sleeve_center = G.P_CENTER_POOLS.Sleeve[G.GAME.selected_sleeve or 1]
    local new_chips, new_mult = sleeve_center:trigger_effect(args)
    if new_chips then
        args.chips = new_chips
    end
    if new_mult then
        args.mult = new_mult
    end
    return old_Back_trigger_effect(self, args)
end

print_trace("CardSleeves loaded~!")

----------------------------------------------
------------MOD CODE END----------------------
