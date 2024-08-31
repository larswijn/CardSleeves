--- STEAMODDED HEADER
--- MOD_NAME: Card Sleeves
--- MOD_ID: CardSleeves
--- MOD_AUTHOR: [LarsWijn, Sable]
--- MOD_DESCRIPTION: Adds sleeves as modifier to decks, similar-ish to stakes.
--- PREFIX: casl
--- VERSION: 1.0.0
--- PRIORITY: -1
--- LOADER_VERSION_GEQ: 1.0.0

----------------------------------------------
------------MOD CODE -------------------------

--[[

KNOWN ISSUES:

* unlocks:
** do not work between restarts
** pop-ups says the completely wrong stuff
* tags on zodiac deck + zodiac sleeve still say "of 5" (e.g. charm tag)

--]]

-- DEBUG FUNCS

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
local function print_error(...)
    return sendErrorMessage(table.concat({ ... }, "\t"), "CardSleeves")
end

local function tprint(tbl, max_indent, _indent)
    if type(tbl) ~= "table" then return tostring(tbl) end
    if not _indent then _indent = 0 end
    if not max_indent then max_indent = 32 end
    local toprint = string.rep(" ", _indent) .. "{\r\n"
    _indent = _indent + 2
    for k, v in pairs(tbl) do
        toprint = toprint .. string.rep(" ", _indent)
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
            if _indent > max_indent then
                toprint = toprint .. tostring(v) .. ",\r\n"
            else
                toprint = toprint .. tostring(v) .. tprint(v, max_indent, _indent + 1) .. ",\r\n"
            end
        else
            toprint = toprint .. "\"" .. tostring(v) .. "\",\r\n"
        end
    end
    toprint = toprint .. string.rep(" ", _indent - 2) .. "}"
    return toprint
end

local function tablesize(tbl)
    local count = 0
    for _ in pairs(tbl) do
        count = count + 1
    end
    return count
end

-- LOCALIZATION

function SMODS.current_mod.process_loc_text()
    G.localization.descriptions.Sleeve = G.localization.descriptions.Sleeve or {}
end

-- ATLAS

SMODS.Atlas {
    key = "sleeve_atlas",
    path = "sleeves.png",
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = "modicon",
    path = "icon.png",
    px = 34,
    py = 34
}

-- SLEEVE BASE CLASS & METHODS

CardSleeves = {}
CardSleeves.Sleeve = SMODS.Center:extend {
    class_prefix = "sleeve",
    discovered = false,
    unlocked = true,
    set = "Sleeve",
    atlas = "sleeve_atlas",
    pos = { x = 0, y = 0 }, -- within `atlas`
    required_params = { "key", "atlas", "pos" },
    pre_inject_class = function(self)
        G.P_CENTER_POOLS[self.set] = {}
    end,
    generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
        if not self.unlocked then
            local target = {
                type = 'descriptions',
                key = self.class_prefix .. "_locked",
                set = self.set,
                nodes = desc_nodes,
                vars = specific_vars or {}
            }
            if self.locked_loc_vars and type(self.locked_loc_vars) == 'function' then
                local res = self:locked_loc_vars(info_queue, card) or {}
                target.vars = res.vars or target.vars
            end
            localize(target)
        else
            return SMODS.Center.generate_ui(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
        end
    end,
    locked_loc_vars = function(self, info_queue, card)
        if not self.unlock_condition then
            error("Please implement custom `locked_loc_vars` or define `unlock_condition` for Sleeve " .. self.name)
        elseif not self.unlock_condition.deck or not self.unlock_condition.stake then
            error("Please implement custom `locked_loc_vars` or define `unlock_condition.deck` and `unlock_condition.stake` for Sleeve " .. self.name)
        end
        local colours = G.C.BLACK
        if self.unlock_condition.stake > 1 then
            colours = get_stake_col(self.unlock_condition.stake)
        end
        local vars = { self.unlock_condition.deck, G.P_CENTER_POOLS.Stake[self.unlock_condition.stake].name, colours = {colours} }
        return { vars = vars }
    end,
    check_for_unlock = function(self, args)
        if not self.unlock_condition then
            error("Please implement custom `check_for_unlock` or define `unlock_condition` for Sleeve " .. self.name)
        elseif not self.unlock_condition.deck or not self.unlock_condition.stake then
            error("Please implement custom `check_for_unlock` or define `unlock_condition.deck` and `unlock_condition.stake` for Sleeve " .. self.name)
        end
        local deck_center = get_deck_from_name(self.unlock_condition.deck)
        if args.type == 'win_deck' and get_deck_win_stake(deck_center.key) >= self.unlock_condition.stake then
            return true
        end
    end,
}

function CardSleeves.Sleeve:apply()
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
                    local card = SMODS.create_card{key=v}
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
        G.GAME.modifiers.money_per_hand = (G.GAME.modifiers.money_per_hand or 1) + self.config.extra_hand_bonus
    end
    if self.config.extra_discard_bonus then
        G.GAME.modifiers.money_per_discard = (G.GAME.modifiers.money_per_discard or 0) + self.config.extra_discard_bonus
    end
end

function CardSleeves.Sleeve:trigger_effect(args)
    if not args then return end

    if self.name == 'Plasma Sleeve' and args.context == 'final_scoring_step' then
        local tot = args.chips + args.mult
        args.chips = math.floor(tot/2)
        args.mult = math.floor(tot/2)
        update_hand_text({delay = 0}, {mult = args.mult, chips = args.chips})

        G.E_MANAGER:add_event(Event({
            func = (function()
                play_sound('gong', 0.94, 0.3)
                play_sound('gong', 0.94*1.5, 0.2)
                play_sound('tarot1', 1.5)
                ease_colour(G.C.UI_CHIPS, {0.8, 0.45, 0.85, 1})
                ease_colour(G.C.UI_MULT, {0.8, 0.45, 0.85, 1})
                attention_text({
                    scale = 1.4, text = localize('k_balanced'), hold = 2, align = 'cm', offset = {x = 0,y = -2.7},major = G.play
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

function CardSleeves.Sleeve.get_current_deck_name()
    return G.GAME.viewed_back and G.GAME.viewed_back.name or
           G.GAME.selected_back and G.GAME.selected_back.name or
           "Red Deck"
end

-- SLEEVE INSTANCES

CardSleeves.Sleeve {
    key = "none",
    name = "No Sleeve",
    atlas = "sleeve_atlas",
    pos = { x = 0, y = 3 },
    config = {},
}

CardSleeves.Sleeve {
    key = "red",
    name = "Red Sleeve",
    atlas = "sleeve_atlas",
    pos = { x = 0, y = 0 },
    config = { discards = 1 },
    unlocked = true,
    unlock_condition = { deck = "Red Deck", stake = 1 },
    loc_vars = function(self)
        return { vars = { self.config.discards } }
    end,
}

CardSleeves.Sleeve {
    key = "blue",
    name = "Blue Sleeve",
    atlas = "sleeve_atlas",
    pos = { x = 1, y = 0 },
    config = { hands = 1 },
    unlocked = true,
    unlock_condition = { deck = "Blue Deck", stake = 2 },
    loc_vars = function(self)
        return { vars = { self.config.hands } }
    end,
}

CardSleeves.Sleeve {
    key = "yellow",
    name = "Yellow Sleeve",
    atlas = "sleeve_atlas",
    pos = { x = 2, y = 0 },
    config = { dollars = 10 },
    unlocked = true,
    unlock_condition = { deck = "Yellow Deck", stake = 3 },
    loc_vars = function(self)
        return { vars = { self.config.dollars } }
    end,
}

CardSleeves.Sleeve {
    key = "green",
    name = "Green Sleeve",
    atlas = "sleeve_atlas",
    pos = { x = 3, y = 0 },
    config = { extra_hand_bonus = 1, extra_discard_bonus = 1, no_interest = true },
    unlocked = true,
    unlock_condition = { deck = "Green Deck", stake = 3 },
    loc_vars = function(self)
        return { vars = { self.config.extra_hand_bonus, self.config.extra_discard_bonus, self.config.no_interest } }
    end,
}

CardSleeves.Sleeve {
    key = "black",
    name = "Black Sleeve",
    atlas = "sleeve_atlas",
    pos = { x = 4, y = 0 },
    config = { hands = -1, joker_slot = 1 },
    unlocked = true,
    unlock_condition = { deck = "Black Deck", stake = 3 },
    loc_vars = function(self)
        return { vars = { self.config.joker_slot, -self.config.hands } }
    end,
}

CardSleeves.Sleeve {
    key = "magic",
    name = "Magic Sleeve",
    atlas = "sleeve_atlas",
    pos = { x = 0, y = 1 },
    unlocked = true,
    unlock_condition = { deck = "Magic Deck", stake = 3 },
    loc_vars = function(self)
        local key
        if self.get_current_deck_name() ~= "Magic Deck" then
            key = self.key
            self.config = { voucher = 'v_crystal_ball', consumables = { 'c_fool', 'c_fool' } }
        else
            key = self.key .. "_alt"
            self.config = { voucher = "v_omen_globe" }
        end
        local vars = { localize{type = 'name_text', key = self.config.voucher, set = 'Voucher'} }
        if self.config.consumables then
            vars[#vars+1] = localize{type = 'name_text', key = self.config.consumables[1], set = 'Tarot'}
        end
        return { key = key, vars = vars }
    end,
}

CardSleeves.Sleeve {
    key = "nebula",
    name = "Nebula Sleeve",
    atlas = "sleeve_atlas",
    pos = { x = 1, y = 1 },
    unlocked = true,
    unlock_condition = { deck = "Nebula Deck", stake = 3 },
    loc_vars = function(self)
        local key
        if self.get_current_deck_name() ~= "Nebula Deck" then
            key = self.key
            self.config = { voucher = 'v_telescope', consumable_slot = -1 }
        else
            key = self.key .. "_alt"
            self.config = { voucher = 'v_observatory' }
        end
        local vars = { localize{type = 'name_text', key = self.config.voucher, set = 'Voucher'} }
        if self.config.consumable_slot then
            vars[#vars+1] = self.config.consumable_slot
        end
        return { key = key, vars = vars }
    end,
}

CardSleeves.Sleeve {
    key = "ghost",
    name = "Ghost Sleeve",
    atlas = "sleeve_atlas",
    pos = { x = 2, y = 1 },
    unlocked = true,
    unlock_condition = { deck = "Ghost Deck", stake = 3 },
    loc_vars = function(self)
        local key
        local vars = {}
        if self.get_current_deck_name() ~= "Ghost Deck" then
            key = self.key
            self.config = { spectral_rate = 2, consumables = { 'c_hex' } }
            vars[#vars+1] = localize{type = 'name_text', key = self.config.consumables[1], set = 'Tarot'}
        else
            key = self.key .. "_alt"
            self.config = { spectral_rate = 4, spectral_more_options = 2 }
            vars[#vars+1] = self.config.spectral_more_options
        end
        return { key = key, vars = vars }
    end,
    trigger_effect = function(self, args)
        local is_spectral_pack = args.context["card"] and args.context.card.ability.set == "Booster" and args.context.card.ability.name:find("Spectral")
        if args.context["create_booster"] and is_spectral_pack and self.config.spectral_more_options then
            args.context.card.ability.extra = args.context.card.ability.extra + self.config.spectral_more_options
        end
    end,
}

CardSleeves.Sleeve {
    key = "abandoned",
    name = "Abandoned Sleeve",
    atlas = "sleeve_atlas",
    pos = { x = 3, y = 1 },
    unlocked = true,
    unlock_condition = { deck = "Abandoned Deck", stake = 3 },
    loc_vars = function(self)
        local key = self.key
        if self.get_current_deck_name() ~= "Abandoned Deck" then
            key = self.key
            self.config = { remove_faces = true }
        else
            key = key .. "_alt"
            self.config = { prevent_faces = true }
        end
        return { key = key }
    end,
    apply = function(self)
        if self.allowed_card_centers == nil then
            self.allowed_card_centers = {}
            self.skip_trigger_effect = true
            for _, card_center in pairs(G.P_CARDS) do
                local card_instance = Card(0, 0, 0, 0, card_center, G.P_CENTERS.c_base)
                if not SMODS.Ranks[card_instance.base.value].face then
                    self.allowed_card_centers[#self.allowed_card_centers+1] = card_center
                end
                card_instance:remove()
            end
            -- TODO: adhere to smodded API?
            self.get_rank_after_10 = function() return "A" end
            self.skip_trigger_effect = false
        end
    end,
    trigger_effect = function(self, args)
        if not self.config.prevent_faces then
            return
        end
        if self.skip_trigger_effect then
            return
        end
        if self.allowed_card_centers == nil then
            self:apply()
        end

        -- handle Familiar, Strength and Ouija
        if args.context["create_consumable"] and args.context["card"] then
            local card = args.context.card
            if card.ability.name == 'Familiar' then
                card.ability.extra = 0
            end
        elseif args.context["before_use_consumable"] and args.context["card"] then
            local card = args.context.card
            if card.ability.name == 'Strength' then
                self.in_strength = true
            elseif card.ability.name == "Ouija" then
                self.in_ouija = true
            end
            if self.in_strength and self.in_ouija then
                print_warning("cannot be in both strength and ouija!")
            end
        elseif args.context["after_use_consumable"] then
            self.in_strength = nil
            self.in_ouija = nil
            self.ouija_rank = nil
        elseif (args.context["create_playing_card"] or args.context["modify_playing_card"]) and args.context["card"] and not is_in_run_info_tab then
            local card = args.context.card
            if SMODS.Ranks[card.base.value].face then
                if self.in_strength then
                    local base_key = SMODS.Suits[card.base.suit].card_key .. "_" .. self.get_rank_after_10()
                    card:set_base(G.P_CARDS[base_key])
                elseif self.in_ouija then
                    if self.ouija_rank == nil then
                        local random_base = pseudorandom_element(self.allowed_card_centers, pseudoseed("slv"))
                        local card_instance = Card(0, 0, 0, 0, random_base, G.P_CENTERS.c_base)
                        self.ouija_rank = SMODS.Ranks[card_instance.base.value]
                        card_instance:remove()
                    end
                    local base_key = SMODS.Suits[card.base.suit].card_key .. "_" .. self.ouija_rank.card_key
                    card:set_base(G.P_CARDS[base_key])
                else
                    local random_base = pseudorandom_element(self.allowed_card_centers, pseudoseed("slv"))
                    card:set_base(random_base)
                end
            end
        end
    end,
}

CardSleeves.Sleeve {
    key = "checkered",
    name = "Checkered Sleeve",
    atlas = "sleeve_atlas",
    pos = { x = 4, y = 1 },
    unlocked = true,
    unlock_condition = { deck = "Checkered Deck", stake = 3 },
    loc_vars = function(self)
        local key
        if self.get_current_deck_name() ~= "Checkered Deck" then
            key = self.key
            self.config = {}
        else
            key = self.key .. "_alt"
            self.config = { force_suits = {["Clubs"] = "Spades", ["Diamonds"] = "Hearts"} }
        end
        return { key = key }
    end,
    trigger_effect = function(self, args)
        if not self.config.force_suits then
            return
        end

        if (args.context["create_playing_card"] or args.context["modify_playing_card"]) and args.context["card"] and not is_in_run_info_tab then
            local card = args.context.card
            for from_suit, to_suit in pairs(self.config.force_suits) do
                if card.base.suit == from_suit then
                        local base = SMODS.Suits[to_suit].card_key .. "_" .. SMODS.Ranks[card.base.value].card_key
                        local initial = G.GAME.blind == nil or args.context["create_playing_card"]
                        card:set_base(G.P_CARDS[base], initial)
                end
            end
        end
    end,
}

CardSleeves.Sleeve {
    key = "zodiac",
    name = "Zodiac Sleeve",
    atlas = "sleeve_atlas",
    pos = { x = 0, y = 2 },
    unlocked = true,
    unlock_condition = { deck = "Zodiac Deck", stake = 3 },
    loc_vars = function(self)
        local key
        local vars = {}
        if self.get_current_deck_name() ~= "Zodiac Deck" then
            key = self.key
            self.config = { vouchers = {'v_tarot_merchant', 'v_planet_merchant', 'v_overstock_norm'} }
            for _, voucher in pairs(self.config.vouchers) do
                vars[#vars+1] = localize{type = 'name_text', key = voucher, set = 'Voucher'}
            end
        else
            key = self.key .. "_alt"
            self.config = { arcana_more_options = 2, celestial_more_options = 2 }
            vars[#vars+1] = self.config.arcana_more_options
            vars[#vars+1] = self.config.celestial_more_options
        end
        return { key = key, vars = vars }
    end,
    trigger_effect = function(self, args)
        if args.context["create_booster"] and args.context["card"] then
            local card = args.context.card
            local is_booster_pack = card.ability.set == "Booster"
            local is_arcana_pack = is_booster_pack and card.ability.name:find("Arcana")
            local is_celestial_pack = is_booster_pack and card.ability.name:find("Celestial")
            if is_arcana_pack and self.config.arcana_more_options then
                card.ability.extra = card.ability.extra + self.config.arcana_more_options
            elseif is_celestial_pack and self.config.celestial_more_options then
                card.ability.extra = card.ability.extra + self.config.celestial_more_options
            end
        end
    end,
}

CardSleeves.Sleeve {
    key = "painted",
    name = "Painted Sleeve",
    atlas = "sleeve_atlas",
    pos = { x = 1, y = 2 },
    unlocked = true,
    unlock_condition = { deck = "Painted Deck", stake = 3 },
    config = {hand_size = 2, joker_slot = -1},
    loc_vars = function(self)
        return { vars = { self.config.hand_size, self.config.joker_slot } }
    end,
}

CardSleeves.Sleeve {
    key = "anaglyph",
    name = "Anaglyph Sleeve",
    atlas = "sleeve_atlas",
    pos = { x = 2, y = 2 },
    unlocked = true,
    unlock_condition = { deck = "Anaglyph Deck", stake = 3 },
    config = {},
    loc_vars = function(self)
        local key
        if self.get_current_deck_name() ~= "Anaglyph Deck" then
            key = self.key
        else
            key = self.key .. "_alt"
        end
        local vars = { localize{type = 'name_text', key = 'tag_double', set = 'Tag'} }
        return { key = key, vars = vars }
    end,
    trigger_effect = function(self, args)
        CardSleeves.Sleeve.trigger_effect(self, args)

        local add_double_tag_event = Event({
            func = (function()
                add_tag(Tag('tag_double'))
                play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
                play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
                return true
            end)
        })
        if self.name == 'Anaglyph Sleeve' and self.get_current_deck_name() ~= "Anaglyph Deck" and args.context == 'eval' and G.GAME.last_blind and G.GAME.last_blind.boss then
            G.E_MANAGER:add_event(add_double_tag_event)
        elseif self.name == 'Anaglyph Sleeve' and self.get_current_deck_name() == "Anaglyph Deck" and args.context == 'eval' and G.GAME.last_blind and not G.GAME.last_blind.boss then
            G.E_MANAGER:add_event(add_double_tag_event)
        end
    end,
}

CardSleeves.Sleeve {
    key = "plasma",
    name = "Plasma Sleeve",
    atlas = "sleeve_atlas",
    pos = { x = 3, y = 2 },
    unlocked = true,
    unlock_condition = { deck = "Plasma Deck", stake = 3 },
    config = {ante_scaling = 2},
    loc_vars = function(self)
        local key
        if self.get_current_deck_name() ~= "Plasma Deck" then
            key = self.key
        else
            key = self.key .. "_alt"
        end
        local vars = { self.config.ante_scaling }
        return { key = key, vars = vars }
    end,
    trigger_effect = function(self, args)
        CardSleeves.Sleeve.trigger_effect(self, args)
        if G.GAME.selected_back.name == "Plasma Deck" and self.name == 'Plasma Sleeve' and args.context == "shop_final_pass" then
            local cardareas = {}
            for _, obj in pairs(G) do
                if type(obj) == "table" and obj["is"] and obj:is(CardArea) and obj.config.type == "shop" then
                    cardareas[#cardareas+1] = obj
                end
            end
            local total_cost, total_items_for_sale = 0, 0
            for i, cardarea in pairs(cardareas) do
                for j, card in pairs(cardarea.cards) do
                    card:set_cost()
                    local has_coupon_tag = card.area and card.ability.couponed and (card.area == G.shop_jokers or card.area == G.shop_booster)
                    if has_coupon_tag then
                        -- tags that set price to 0 (coupon, uncommon, rare, etc)
                        card.cost = 0
                        card.ability.couponed = false
                    end
                    total_cost = total_cost + card.cost
                    total_items_for_sale = total_items_for_sale + 1
                end
            end
            local avg_cost = math.floor(total_cost / total_items_for_sale)
            G.E_MANAGER:add_event(Event({
                func = (function()
                    play_sound('gong', 0.94, 0.3)
                    play_sound('gong', 0.94*1.5, 0.2)
                    play_sound('tarot1', 1.5)
                    attention_text({
                        scale = 1.3,
                        colour = G.C.GOLD,
                        text = localize('k_balanced'),
                        hold = 2,
                        align = 'cm',
                        offset = {x = 0, y = 0},
                        major = G.play
                    })
                    return true
                end)
            }))

            -- delay(0.6)
            for _, cardarea in pairs(cardareas) do
                for _, card in pairs(cardarea.cards) do
                    -- could maybe use `function ease_value` instead?
                    card.cost = avg_cost
                    -- card:set_cost()  
                end
            end
        end
    end
}

CardSleeves.Sleeve {
    key = "erratic",
    name = "Erratic Sleeve",
    atlas = "sleeve_atlas",
    pos = { x = 4, y = 2 },
    unlocked = true,
    unlock_condition = { deck = "Erratic Deck", stake = 3 },
    config = {randomize_rank_suit = true},
    loc_vars = function(self)
        local key
        if self.get_current_deck_name() ~= "Erratic Deck" then
            key = self.key
            self.config = {randomize_rank_suit = true}
        else
            key = self.key .. "_alt"
            self.config = {randomize_rank_suit = true,
                           randomize_start = true,
                           random_lb = 2,
                           random_ub = 6}
        end
        local vars = {}
        if self.config.randomize_start then
            vars[#vars+1] = self.config.random_lb
            vars[#vars+1] = self.config.random_ub
        end
        return { key = key, vars = vars }
    end,
    apply = function(self)
        CardSleeves.Sleeve.apply(self)
        if self.config.randomize_start then
            local function get_random()
                return pseudorandom("slv", self.config.random_lb, self.config.random_ub)
            end

            G.GAME.starting_params.hands = get_random()
            G.GAME.starting_params.discards = get_random()
            G.GAME.starting_params.dollars = get_random()
            G.GAME.starting_params.joker_slots = get_random()
        end
    end,
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

local function create_sleeve_card(area)
    local new_card = Card(area.T.x, area.T.y, area.T.w, area.T.h,
                          nil, G.P_CENTERS.c_base, {playing_card = 11, viewed_back = true})
    new_card.sprite_facing = 'back'
    new_card.facing = 'back'
    return new_card
end

local function create_sleeve_sprite(x, y, w, h, sleeve_center)
    -- uses locked sprite if sleeve is locked - assumes the locked sprite is at (x=0, y=4)
    if sleeve_center.unlocked == false then
        return Sprite(x, y, w, h, G.ASSET_ATLAS[sleeve_center.atlas], {x=0, y=3})
    else
        return Sprite(x, y, w, h, G.ASSET_ATLAS[sleeve_center.atlas], sleeve_center.pos)
    end
end

local function replace_sleeve_sprite(card, sleeve_center)
    if card.children.back then
        card.children.back:remove()
    end
    card.children.back = create_sleeve_sprite(card.T.x, card.T.y, card.T.w + 0.1, card.T.h, sleeve_center)
    card.children.back:set_role({major = card, role_type = 'Minor', draw_major = card, offset = {x=-0.05, y=0.25}})
end

local function insert_sleeve_card(area)
    local sleeve_center = G.P_CENTER_POOLS.Sleeve[G.viewed_sleeve or 1]
    local _, sleeve_card = find_sleeve_card(area)
    if sleeve_center.name ~= "No Sleeve" then
        if sleeve_card == nil then
            local new_card = create_sleeve_card(area)
            replace_sleeve_sprite(new_card, sleeve_center)
            area:emplace(new_card)
        else
            replace_sleeve_sprite(sleeve_card, sleeve_center)
        end
    elseif sleeve_center.name == "No Sleeve" and sleeve_card then
        sleeve_card:remove()
    elseif sleeve_card then
        print_warning("Unexpected sleeve_card properties!")
    end
end

function G.FUNCS.change_sleeve(args)
    G.viewed_sleeve = args.to_key
    G.PROFILES[G.SETTINGS.profile].MEMORY.sleeve = args.to_key
end

local in_collection_deck = false  -- here because lua globals/locals are being weird?
function G.FUNCS.change_viewed_sleeve()
    if in_collection_deck then
        return
    end
    local area = G.sticker_card.area
    return insert_sleeve_card(area)
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
    local sleeve_center = G.P_CENTER_POOLS.Sleeve[_sleeve]
    local ret_nodes = {}
    local sleeve_text = ""
    if sleeve_center then
        if sleeve_center.unlocked then
            sleeve_text = localize { type = 'name_text', key = sleeve_center.key, set = sleeve_center.set }
        else
            sleeve_text = "Locked"
        end
        sleeve_center:generate_ui({}, nil, ret_nodes, nil, {name = {}})
    end

    local desc_t = {}
    for k, v in ipairs(ret_nodes) do
        for k2, v2 in pairs(v) do
            if v2["config"] ~= nil and v2["config"]["scale"] ~= nil then
                v[k2].config.scale = v[k2].config.scale / 1.2
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
                    { n = G.UIT.T, config = { text = sleeve_text,
                      scale = 0.35, colour = G.C.WHITE } }
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
    for _, v in pairs(G.P_CENTER_POOLS.Sleeve) do
        -- if v.unlocked then
        table.insert(sleeve_options, v)
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

function G.UIDEF.current_sleeve(_scale)
    local _scale = _scale or 1
    local sleeve_center = G.P_CENTER_POOLS.Sleeve[G.GAME.selected_sleeve or 1]
    local sleeve_sprite = create_sleeve_sprite(0, 0, _scale*1, _scale*(95/71), sleeve_center)
    sleeve_sprite.states.drag.can = false
    return {
        n = G.UIT.ROOT,
        config = { align = "cm", colour = G.C.BLACK, r = 0.1, padding = 0.1},
        nodes = {
            {
                n = G.UIT.R,
                config = { align = "cm", colour = G.C.BLACK, padding = 0.1, minw = 4 },
                nodes = {
                    { n = G.UIT.O, config = { colour = G.C.BLACK, object = sleeve_sprite, hover = true, can_collide = false } },
                    { n = G.UIT.T, config = { text = "Sleeve", scale = 0.5, colour = G.C.WHITE } }
                }
            },
            {
                n = G.UIT.R,
                config = { align = "cm", padding = 0.1 },
                nodes = {
                    G.UIDEF.sleeve_description(G.GAME.selected_sleeve)
                }
            }
        }
    }
end

--[[ HOOKING / WRAPPING FUNCS

*List of functions we hook into and change its output or properties:
 (not a full list) (also see lovely.toml)
**G.UIDEF.run_setup_option
**G.FUNCS.can_start_run
**G.FUNCS.change_viewed_back
**Game:init_game_object
**Back:apply_to_run
**Back:trigger_effect
**CardArea:draw
**create_tabs
**Controller:snap_to
**Card:set_base
**Card:use_consumeable
**CardArea:unhighlight_all
**create_UIBox_arcana_pack
**create_UIBox_spectral_pack
**create_UIBox_standard_pack  
**create_UIBox_buffoon_pack
**create_UIBox_celestial_pack
--]]

local old_uidef_run_setup_option = G.UIDEF.run_setup_option
function G.UIDEF.run_setup_option(_type)
    local output = old_uidef_run_setup_option(_type)
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

local old_FUNCS_change_viewed_back = G.FUNCS.change_viewed_back
function G.FUNCS.change_viewed_back(args)
    local area = G.sticker_card.area
    local _, sleeve_card = find_sleeve_card(area)
    if sleeve_card then
        sleeve_card:remove()
    end

    old_FUNCS_change_viewed_back(args)

    G.FUNCS.change_viewed_sleeve()
end

local old_FUNCS_can_start_run = G.FUNCS.can_start_run
function G.FUNCS.can_start_run(e)
    old_FUNCS_can_start_run(e)
    if G.P_CENTER_POOLS.Sleeve[G.viewed_sleeve or 1].unlocked == false then
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    end
end

local old_Game_init_game_object = Game.init_game_object
function Game:init_game_object()
    local output = old_Game_init_game_object(self)
    output.selected_sleeve = G.viewed_sleeve or 1
    return output
end

local old_Back_apply_to_run = Back.apply_to_run
function Back:apply_to_run()
    local sleeve_center = G.P_CENTER_POOLS.Sleeve[G.GAME.selected_sleeve or 1]
    old_Back_apply_to_run(self)
    sleeve_center:apply()
end

local old_Back_trigger_effect = Back.trigger_effect
function Back:trigger_effect(args)
    local sleeve_center = G.P_CENTER_POOLS.Sleeve[G.GAME.selected_sleeve or 1]
    local new_chips, new_mult

    new_chips, new_mult = old_Back_trigger_effect(self, args)
    args.chips, args.mult = new_chips or args.chips, new_mult or args.mult

    new_chips, new_mult = sleeve_center:trigger_effect(args)
    args.chips, args.mult = new_chips or args.chips, new_mult or args.mult

    return args.chips, args.mult
end

local old_CardArea_draw = CardArea.draw
function CardArea:draw()
    if not self.states.visible then return end
    if G.VIEWING_DECK and (self==G.deck or self==G.hand or self==G.play) then return end

    local draw_sleeve = self == G.deck and G.GAME.selected_sleeve and G.GAME.selected_sleeve > 1

    if draw_sleeve and self.children["view_deck"] then
        -- prevent drawing this, we'll draw it ourselves later
        local old_view_deck_draw = self.children.view_deck.draw
        self.children.view_deck.draw = function() end
    end

    old_CardArea_draw(self)

    if draw_sleeve then
        local sleeve_center = G.P_CENTER_POOLS.Sleeve[G.GAME.selected_sleeve]
        local x = self.T.x
        local width = self.T.w
        if self.cards[2] then
            -- using 2nd card because player can move the first card anywhere
            x = self.cards[#self.cards].T.x
            width = self.cards[2].T.w + (self.cards[2].T.x - self.cards[#self.cards].T.x)
        end
        if self.sleeve_sprite == nil then
            self.sleeve_sprite = create_sleeve_sprite(x, self.T.y, width, self.T.h, sleeve_center)
            -- self.sleeve_sprite.states.drag.can = false
        else
            -- update x & width
            self.sleeve_sprite.T.x = x
            self.sleeve_sprite.T.w = width
        end
        self.sleeve_sprite:draw()
        if self.children["view_deck"] and G.deck_preview or self.states.collide.is or (G.buttons and G.buttons.states.collide.is and G.CONTROLLER.HID.controller) then
            -- restore draw behavior of "view deck" so it can be drawn on top of sleeve sprite
            self.children.view_deck.draw = old_view_deck_draw
            self.children.view_deck:draw()
        end
    end
end

local is_in_run_info_tab = false
local old_uidef_run_info = G.UIDEF.run_info
function G.UIDEF.run_info()
    is_in_run_info_tab = true
    local output = old_uidef_run_info()
    is_in_run_info_tab = false
    return output
end

local old_create_tabs = create_tabs
function create_tabs(args)
    if args["tabs"] and is_in_run_info_tab and G.GAME.selected_sleeve > 1 then
        args.tabs[#args.tabs+1] = {
            label = "Sleeve",
            tab_definition_function = G.UIDEF.current_sleeve
        }
    end

    return old_create_tabs(args)
end

local old_Controller_snap_to = Controller.snap_to
function Controller:snap_to(args)
    -- hooking into this might not be a good idea tbh, but I don't have a controller to test it, so...
    -- TODO: see if there's a better way to do this (Game:update_shop?)
    local in_shop_load = G["shop"] and
                         (args.node == G.shop:get_UIE_by_ID('next_round_button') or
                          args.node["area"] and args.node.area["config"] and args.node.area.config.type == "shop")
    if in_shop_load then
        -- shop has been loaded/rerolled/etc
        local sleeve_center = G.P_CENTER_POOLS.Sleeve[G.GAME.selected_sleeve or 1]
        G.E_MANAGER:add_event(Event({
            delay = 0.01,  --  because stupid fucking tags not applying immediately
            blockable = true,
            trigger = 'after',
            func = function()
                sleeve_center:trigger_effect{context = "shop_final_pass"}
                return true
            end
        }))
    end
    return old_Controller_snap_to(self, args)
end

local old_Card_set_base = Card.set_base
function Card:set_base(card, initial)
    local sleeve_center = G.P_CENTER_POOLS.Sleeve[G.GAME.selected_sleeve or 1]

    local output = old_Card_set_base(self, card, initial)

    local is_playing_card = (self.ability.set == "Default" or self.ability.set == "Enhanced") and self.config.card_key
    if initial and self.ability.set == "Booster" then
        sleeve_center:trigger_effect{context = {create_booster = true, card = self}}
    elseif is_playing_card then
        if initial then
            sleeve_center:trigger_effect{context = {create_playing_card = true, card = self}}
        else
            sleeve_center:trigger_effect{context = {modify_playing_card = true, card = self}}
        end
    elseif initial and (self.ability.set == "Tarot" or self.ability.set == "Planet" or self.ability.set == "Spectral") then
        sleeve_center:trigger_effect{context = {create_consumable = true, card = self}}
    end

    return output
end

local old_Card_use_consumable = Card.use_consumeable
function Card:use_consumeable(...)
    local sleeve_center = G.P_CENTER_POOLS.Sleeve[G.GAME.selected_sleeve or 1]
    sleeve_center:trigger_effect{context = {before_use_consumable = true, card = self}}

    local output = old_Card_use_consumable(self, ...)

    G.E_MANAGER:add_event(Event({
        delay = 0.01,  --  because consumables don't apply immediately
        blockable = true,
        trigger = 'after',
        func = function()
            sleeve_center:trigger_effect{context = {after_use_consumable = true}}
            return true
        end
    }))
    return output
end

local function booster_pack_size_fix_wrapper(func)
    -- fix the cardarea for these booster packs growing way too big
    local function wrapper(...)
        local old_pack_size = G.GAME.pack_size
        G.GAME.pack_size = math.min(G.GAME.pack_size, 5)  -- 6 is fine for tarot packs, but not for celestial packs
        local output = func()
        G.GAME.pack_size = old_pack_size
        return output
    end
    return wrapper
end
create_UIBox_arcana_pack = booster_pack_size_fix_wrapper(create_UIBox_arcana_pack)
create_UIBox_spectral_pack = booster_pack_size_fix_wrapper(create_UIBox_spectral_pack)
create_UIBox_standard_pack = booster_pack_size_fix_wrapper(create_UIBox_standard_pack)
create_UIBox_buffoon_pack = booster_pack_size_fix_wrapper(create_UIBox_buffoon_pack)
create_UIBox_celestial_pack = booster_pack_size_fix_wrapper(create_UIBox_celestial_pack)

local old_FUNCS_your_collection_decks = G.FUNCS.your_collection_decks
function G.FUNCS.your_collection_decks(...)
    in_collection_deck = true
    return old_FUNCS_your_collection_decks(...)
end
local old_FUNCS_your_collection = G.FUNCS.your_collection
function G.FUNCS.your_collection(...)
    in_collection_deck = false
    return old_FUNCS_your_collection(...)
end

local old_smods_save_unlocks = SMODS.SAVE_UNLOCKS
function SMODS.SAVE_UNLOCKS()
    -- TODO: create PR to fix SMODS.SAVE_UNLOCKS itself?
    -- TODO: also, unlock menu says the completely wrong stuff ("joker unlocked" etc)
    old_smods_save_unlocks()

    for _, v in pairs(G.P_CENTER_POOLS.Sleeve) do
        if v.unlocked == false then
            G.P_LOCKED[#G.P_LOCKED+1] = v
        end
    end
end

print_trace("CardSleeves loaded~!")

----------------------------------------------
------------MOD CODE END----------------------
