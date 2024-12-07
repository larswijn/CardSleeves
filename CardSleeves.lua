--- STEAMODDED HEADER
--- MOD_NAME: Card Sleeves
--- MOD_ID: CardSleeves
--- BADGE_COLOR: 0047AA
--- MOD_AUTHOR: [LarsWijn]
--- MOD_DESCRIPTION: Adds sleeves as modifier to decks. Art by Sable.
--- PREFIX: casl
--- VERSION: 1.4.8
--- PRIORITY: -1
--- DEPENDS: [Steamodded>=1.0.0~ALPHA-0924a]
--- CONFLICTS: [GRM<=0.9.5]

----------------------------------------------
------------MOD CODE -------------------------

--[[

KNOWN ISSUES/TODO IDEAS:

* Issue: What if locked sleeves in challenge?
* Minor Issue: Tags for booster packs have wrong description when using double zodiac/ghost

* API:
** add optional shaders

* IDEAS:
** See if people want to select their own sleeves in challenges instead of adhering to the challenge?
** Yellow deck+sleeve has unique interest mechanic?
** See if people want unique sleeves?

--]]

-- GLOBALS (in this mod)

CardSleeves = SMODS.current_mod

local in_collection = false
local is_in_run_info_tab = false
local game_args = {}

local sleeve_count_horizontal = 6
local sleeve_count_vertical = 2
local sleeve_count_page = sleeve_count_horizontal * sleeve_count_vertical
local sleeve_card_areas = {}

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

    max_indent = max_indent or 16
    _indent = _indent or 0
    local toprint = string.rep(" ", _indent) .. "{\r\n"

    _indent = _indent + 2
    for k, v in pairs(tbl) do
        local key_str, value_str
        if type(k) == "number" then
            key_str = "[" .. k .. "]"
        else
            key_str = tostring(k)
        end
        if type(v) == "string" then
            if k == "content" then
                value_str = "..."
            else
                value_str = '"' .. v .. '"'
            end
        elseif type(v) == "table" and _indent <= max_indent then
            value_str = tostring(v) .. tprint(v, max_indent, _indent)
        else
            value_str = tostring(v)
        end
        toprint = toprint .. string.rep(" ", _indent) .. key_str .. " = " .. value_str .. ",\r\n"
    end

    return toprint .. string.rep(" ", _indent - 2) .. "}"
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
    -- will crash the game if removed
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

CardSleeves.Sleeve = SMODS.Center:extend {
    class_prefix = "sleeve",
    discovered = false,
    unlocked = true,
    set = "Sleeve",
    config = {},
    required_params = { "key", "atlas", "pos" },
    pre_inject_class = function(self)
        G.P_CENTER_POOLS[self.set] = {}
    end,
    get_obj = function(self, key)
        if key == nil then
            return nil
        end
        return self.obj_table[key] or SMODS.Center:get_obj(key)
    end
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
                for _, v in ipairs(self.config.consumables) do
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
        for _, v in pairs(self.config.vouchers) do
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

function CardSleeves.Sleeve:locked_loc_vars(info_queue, card)
    if not self.unlock_condition then
        error("Please implement custom `locked_loc_vars` or define `unlock_condition` for Sleeve " .. self.key)
    elseif not self.unlock_condition.deck or not self.unlock_condition.stake then
        error("Please implement custom `locked_loc_vars` or define `unlock_condition.deck` and `unlock_condition.stake` for Sleeve " .. self.key)
    end
    local deck_name = localize{type = "name_text", set = "Back", key = self.unlock_condition.deck}
    local stake_name = localize{type = "name_text", set = "Stake", key = SMODS.stake_from_index(self.unlock_condition.stake)}
    local colours = G.C.GREY
    if self.unlock_condition.stake > 1 then
        colours = get_stake_col(self.unlock_condition.stake)
    end
    local vars = { deck_name, stake_name, colours = {colours} }
    return { vars = vars }
end

function CardSleeves.Sleeve:check_for_unlock(args)
    if not self.unlock_condition then
        error("Please implement custom `check_for_unlock` or define `unlock_condition` for Sleeve " .. self.key)
    elseif not self.unlock_condition.deck or not self.unlock_condition.stake then
        error("Please implement custom `check_for_unlock` or define `unlock_condition.deck` and `unlock_condition.stake` for Sleeve " .. self.key)
    end
    if args.type == 'win_deck' and get_deck_win_stake(self.unlock_condition.deck) >= self.unlock_condition.stake then
        return true
    end
end

function CardSleeves.Sleeve:is_unlocked()
    -- Checks self.unlocked, CardSleeves config, and basegame Unlock All. Use this to read self.unlocked unless you know what you're doing
    return self.unlocked or CardSleeves.config.allow_any_sleeve_selection or G.PROFILES[G.SETTINGS.profile].all_unlocked
end

function CardSleeves.Sleeve:get_name()
    if self:is_unlocked() then
        return localize{type = "name_text", set = self.set, key = self.key}
    else
        return localize('k_locked')
    end
end

function CardSleeves.Sleeve:generate_ui(info_queue, card, desc_nodes, specific_vars, full_UI_table)
    if not self:is_unlocked() then
        local target = {
            type = 'descriptions',
            key = self.class_prefix .. "_locked",
            set = self.set,
            nodes = desc_nodes,
            vars = specific_vars or {}
        }
        if self.locked_loc_vars and type(self.locked_loc_vars) == 'function' then
            local res = self:locked_loc_vars(info_queue, card) or {}
            target.key = res.key or target.key
            target.vars = res.vars or target.vars
        end
        localize(target)
    else
        return SMODS.Center.generate_ui(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    end
end

function CardSleeves.Sleeve.get_current_deck_key()
    if Galdur and Galdur.config.use and Galdur.run_setup.choices.deck then
        return Galdur.run_setup.choices.deck.effect.center.key
    elseif G.GAME.viewed_back then
        return G.GAME.viewed_back.effect.center.key
    elseif G.GAME.selected_back then
        return G.GAME.selected_back.effect.center.key
    end
    return "b_red"
end

function CardSleeves.Sleeve.get_current_deck_name()
    print_debug("DEPRECATED: `get_current_deck_name` will be removed in a future version, use `get_current_deck_key` instead")
    return (Galdur and Galdur.config.use and Galdur.run_setup.choices.deck) and Galdur.run_setup.choices.deck.name or
            G.GAME.viewed_back and G.GAME.viewed_back.name or
            G.GAME.selected_back and G.GAME.selected_back.name or
            "Red Deck"
end

-- SLEEVE INSTANCES

CardSleeves.Sleeve {
    key = "none",
    name = "No Sleeve",
    atlas = "sleeve_atlas",
    pos = { x = 4, y = 3 },
    config = {},
}

CardSleeves.Sleeve {
    key = "red",
    name = "Red Sleeve",
    atlas = "sleeve_atlas",
    pos = { x = 0, y = 0 },
    config = { discards = 1 },
    unlocked = false,
    unlock_condition = { deck = "b_red", stake = 2 },
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
    unlocked = false,
    unlock_condition = { deck = "b_blue", stake = 3 },
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
    unlocked = false,
    unlock_condition = { deck = "b_yellow", stake = 3 },
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
    unlocked = false,
    unlock_condition = { deck = "b_green", stake = 3 },
    loc_vars = function(self)
        return { vars = { self.config.extra_hand_bonus, self.config.extra_discard_bonus, self.config.no_interest } }
    end,
}

CardSleeves.Sleeve {
    key = "black",
    name = "Black Sleeve",
    atlas = "sleeve_atlas",
    pos = { x = 4, y = 0 },
    unlocked = false,
    unlock_condition = { deck = "b_black", stake = 3 },
    loc_vars = function(self)
        local key, vars
        if self.get_current_deck_key() ~= "b_black" then
            key = self.key
            self.config = { hands = -1, joker_slot = 1 }
            vars = { self.config.joker_slot, -self.config.hands }
        else
            key = self.key .. "_alt"
            self.config = { discards = -1, joker_slot = 1 }
            vars = { self.config.joker_slot, -self.config.discards }
        end
        return { key = key, vars = vars }
    end,
}

CardSleeves.Sleeve {
    key = "magic",
    name = "Magic Sleeve",
    atlas = "sleeve_atlas",
    pos = { x = 0, y = 1 },
    unlocked = false,
    unlock_condition = { deck = "b_magic", stake = 4 },
    loc_vars = function(self)
        local key
        if self.get_current_deck_key() ~= "b_magic" then
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
    unlocked = false,
    unlock_condition = { deck = "b_nebula", stake = 4 },
    loc_vars = function(self)
        local key
        if self.get_current_deck_key() ~= "b_nebula" then
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
    unlocked = false,
    unlock_condition = { deck = "b_ghost", stake = 4 },
    loc_vars = function(self)
        local key
        local vars = {}
        if self.get_current_deck_key() ~= "b_ghost" then
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
        if args.context.create_card and args.context.card then
            local card = args.context.card
            local is_spectral_pack = card.ability.set == "Booster" and card.ability.name:find("Spectral")
            if is_spectral_pack and self.config.spectral_more_options then
               card.ability.extra = card.ability.extra + self.config.spectral_more_options
            end
        end
    end,
}

CardSleeves.Sleeve {
    key = "abandoned",
    name = "Abandoned Sleeve",
    atlas = "sleeve_atlas",
    pos = { x = 3, y = 1 },
    unlocked = false,
    unlock_condition = { deck = "b_abandoned", stake = 4 },
    loc_vars = function(self)
        local key = self.key
        if self.get_current_deck_key() ~= "b_abandoned" then
            key = self.key
            self.config = { remove_faces = true }
        else
            key = key .. "_alt"
            self.config = { prevent_faces = true }
        end
        return { key = key }
    end,
    apply = function(self)
        CardSleeves.Sleeve.apply(self)
        if self.config.prevent_faces and self.allowed_card_centers == nil then
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

        -- handle Strength and Ouija
        local card = args.context.card
        local is_playing_card = card and (card.ability.set == "Default" or card.ability.set == "Enhanced") and card.config.card_key
        if args.context.before_use_consumable and card then
            if card.ability.name == 'Strength' then
                self.in_strength = true
            elseif card.ability.name == "Ouija" then
                self.in_ouija = true
            end
            if self.in_strength and self.in_ouija then
                print_warning("cannot be in both strength and ouija!")
            end
        elseif args.context.after_use_consumable then
            self.in_strength = nil
            self.in_ouija = nil
            self.ouija_rank = nil
        elseif (args.context.create_card or args.context.modify_playing_card) and card and is_playing_card then
            if SMODS.Ranks[card.base.value].face then
                local initial = G.GAME.blind == nil or args.context.create_card
                if self.in_strength then
                    local base_key = SMODS.Suits[card.base.suit].card_key .. "_" .. self.get_rank_after_10()
                    card:set_base(G.P_CARDS[base_key], initial)
                elseif self.in_ouija then
                    if self.ouija_rank == nil then
                        local random_base = pseudorandom_element(self.allowed_card_centers, pseudoseed("slv"))
                        local card_instance = Card(0, 0, 0, 0, random_base, G.P_CENTERS.c_base)
                        self.ouija_rank = SMODS.Ranks[card_instance.base.value]
                        card_instance:remove()
                    end
                    local base_key = SMODS.Suits[card.base.suit].card_key .. "_" .. self.ouija_rank.card_key
                    card:set_base(G.P_CARDS[base_key], initial)
                else
                    local random_base = pseudorandom_element(self.allowed_card_centers, pseudoseed("slv"))
                    card:set_base(random_base, initial)
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
    unlocked = false,
    unlock_condition = { deck = "b_checkered", stake = 4 },
    loc_vars = function(self)
        local key
        if self.get_current_deck_key() ~= "b_checkered" then
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

        local card = args.context.card
        local is_playing_card = card and (card.ability.set == "Default" or card.ability.set == "Enhanced") and card.config.card_key
        if (args.context.create_card or args.context.modify_playing_card) and card and is_playing_card then
            for from_suit, to_suit in pairs(self.config.force_suits) do
                if card.base.suit == from_suit then
                    local base = SMODS.Suits[to_suit].card_key .. "_" .. SMODS.Ranks[card.base.value].card_key
                    local initial = G.GAME.blind == nil or args.context.create_card
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
    unlocked = false,
    unlock_condition = { deck = "b_zodiac", stake = 5 },
    loc_vars = function(self)
        local key
        local vars = {}
        if self.get_current_deck_key() ~= "b_zodiac" then
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
        if args.context.create_card and args.context.card then
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
    unlocked = false,
    unlock_condition = { deck = "b_painted", stake = 5 },
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
    unlocked = false,
    unlock_condition = { deck = "b_anaglyph", stake = 5 },
    config = {},
    loc_vars = function(self)
        local key
        if self.get_current_deck_key() ~= "b_anaglyph" then
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
        if self.name == 'Anaglyph Sleeve' and self.get_current_deck_key() ~= "b_anaglyph" and args.context == 'eval' and G.GAME.last_blind and G.GAME.last_blind.boss then
            G.E_MANAGER:add_event(add_double_tag_event)
        elseif self.name == 'Anaglyph Sleeve' and self.get_current_deck_key() == "b_anaglyph" and args.context == 'eval' and G.GAME.last_blind and not G.GAME.last_blind.boss then
            G.E_MANAGER:add_event(add_double_tag_event)
        end
    end,
}

CardSleeves.Sleeve {
    key = "plasma",
    name = "Plasma Sleeve",
    atlas = "sleeve_atlas",
    pos = { x = 3, y = 2 },
    unlocked = false,
    unlock_condition = { deck = "b_plasma", stake = 6 },
    config = {ante_scaling = 2},
    loc_vars = function(self)
        local key
        if self.get_current_deck_key() ~= "b_plasma" then
            key = self.key
        else
            key = self.key .. "_alt"
        end
        local vars = { self.config.ante_scaling }
        return { key = key, vars = vars }
    end,
    trigger_effect = function(self, args)
        -- TODO: don't balance chips/mult twice for no reason?
        CardSleeves.Sleeve.trigger_effect(self, args)
        -- TODO: this isn't API friendly?
        if self.get_current_deck_key() == "b_plasma" and self.name == 'Plasma Sleeve' and args.context == "shop_final_pass" then
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
    unlocked = false,
    unlock_condition = { deck = "b_erratic", stake = 7 },
    config = {randomize_rank_suit = true},
    loc_vars = function(self)
        local key
        if self.get_current_deck_key() ~= "b_erratic" then
            key = self.key
            self.config = {randomize_rank_suit = true}
        else
            key = self.key .. "_alt"
            self.config = {randomize_rank_suit = true,
                           randomize_start = true,
                           random_lb = 3,
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

-- LOCAL FUNCS

local function get_sleeve_win_sticker(sleeve_key)
    local profile = G.PROFILES[G.SETTINGS.profile]
    if profile.sleeve_usage and profile.sleeve_usage[sleeve_key] and profile.sleeve_usage[sleeve_key].wins_by_key then
        local _stake = nil
		for key, _ in pairs(profile.sleeve_usage[sleeve_key].wins_by_key) do
			if (G.P_STAKES[key] and G.P_STAKES[key].stake_level or 0) > (_stake and G.P_STAKES[_stake].stake_level or 0) then
				_stake = key
			end
		end
		if _stake then
            return G.sticker_map[_stake]
        end
    end
end

local function find_sleeve_card(area)
    -- return (index, card) or nil
    -- loop safeguard in case some other mod decides to modify this (which would be dumb, but we did it, so...)
    for i, v in pairs(area.cards) do
        if v.params.sleeve_card then
            return i, v
        end
    end
end

local function create_sleeve_card(area, sleeve_center)
    local viewed_back = G.GAME.viewed_back ~= nil and {effect = {config = {}}} or false  -- cryptid compat
    local new_card = Card(area.T.x, area.T.y, area.T.w + 0.1, area.T.h,
                          nil, sleeve_center or G.P_CENTERS.c_base,
                          {playing_card = 11, viewed_back = viewed_back, galdur_selector = true, sleeve_card = true})
    new_card.sprite_facing = 'back'
    new_card.facing = 'back'
    return new_card
end

local function create_sleeve_sprite(x, y, w, h, sleeve_center)
    -- uses locked sprite if sleeve is locked - assumes the locked sprite is at (x=0, y=3)
    if sleeve_center:is_unlocked() then
        return Sprite(x, y, w, h, G.ASSET_ATLAS[sleeve_center.atlas], sleeve_center.pos)
    else
        return Sprite(x, y, w, h, G.ASSET_ATLAS["casl_sleeve_atlas"], {x=0, y=3})  -- string in case modded sleeve has custom atlas
    end
end

local function replace_sleeve_sprite(card, sleeve_center, offset)
    offset = offset or {x=0, y=0.35}
    if card.children.back then
        card.children.back:remove()
    end
    card.children.back = create_sleeve_sprite(card.T.x + offset.x, card.T.y + offset.y, card.T.w, card.T.h, sleeve_center)
    card.children.back:set_role{major = card, role_type = 'Minor', draw_major = card, offset = offset}
    if sleeve_center.key ~= "sleeve_casl_none" then
        card.sticker = get_sleeve_win_sticker(sleeve_center.key)
        card.sticker_rotation = math.pi
    end
end

local function insert_sleeve_card(area, sleeve_center)
    local _, sleeve_card = find_sleeve_card(area)
    if sleeve_center.name ~= "No Sleeve" then
        if sleeve_card == nil then
            local new_card = create_sleeve_card(area, sleeve_center)
            replace_sleeve_sprite(new_card, sleeve_center)
            area:emplace(new_card)
            return new_card
        else
            sleeve_card.config.center = sleeve_center
            replace_sleeve_sprite(sleeve_card, sleeve_center)
            return sleeve_card
        end
    elseif sleeve_center.name == "No Sleeve" and sleeve_card then
        sleeve_card:remove()
    elseif sleeve_card then
        print_warning("Unexpected sleeve_card properties!")
    end
end

local function create_sleeve_badges(sleeve_center)
    local restore_dependencies = false
    if sleeve_center.mod.id ~= "CardSleeves" and not sleeve_center.dependencies then
        sleeve_center.dependencies = {"CardSleeves"}
        restore_dependencies = true
    end
    local badges = {}
    SMODS.create_mod_badges(sleeve_center, badges)
    if restore_dependencies then
        sleeve_center.dependencies = nil
    end
    if badges then
        local nodes = {}
        for k, v in ipairs(badges) do
            nodes[k] = v
        end
        return {
            n = G.UIT.R,
            config = {align = "cm", padding = 0.1},
            nodes = nodes
        }
    end
    return {n=G.UIT.R}
end

local function booster_pack_size_fix_wrapper(func)
    -- fix the cardarea for these booster packs growing way too big
    local function wrapper(...)
        local old_pack_size = G.GAME.pack_size
        G.GAME.pack_size = math.min(G.GAME.pack_size, 5)  -- 6 is fine for tarot packs, but not for celestial packs
        local output = func(...)
        G.GAME.pack_size = old_pack_size
        return output
    end
    return wrapper
end

local function set_sleeve_usage()
    if G.GAME.selected_sleeve then
        local sleeve_center = CardSleeves.Sleeve:get_obj(G.GAME.selected_sleeve)
        if sleeve_center then
            if not G.PROFILES[G.SETTINGS.profile].sleeve_usage then
                G.PROFILES[G.SETTINGS.profile].sleeve_usage = {}
            end
            if not G.PROFILES[G.SETTINGS.profile].sleeve_usage[G.GAME.selected_sleeve] then
                G.PROFILES[G.SETTINGS.profile].sleeve_usage[G.GAME.selected_sleeve] = {count = 1, wins = {}, losses = {}, wins_by_key = {}, losses_by_key = {}}
            end
        end
    end
end

-- GLOBAL (UI) FUNCS

function G.FUNCS.change_sleeve(args)
    local sleeve_center = G.P_CENTER_POOLS.Sleeve[args.to_key]
    G.viewed_sleeve = sleeve_center.key
    G.PROFILES[G.SETTINGS.profile].MEMORY.sleeve = sleeve_center.key
    if sleeve_center["loc_vars"] then
        sleeve_center:loc_vars()
    end
end

function G.FUNCS.change_viewed_sleeve()
    if in_collection then
        return
    end
    local area = G.sticker_card.area
    local sleeve_center = CardSleeves.Sleeve:get_obj(G.viewed_sleeve)
    if sleeve_center then
        insert_sleeve_card(area, sleeve_center)
    else
        print_error("Selected sleeve could not be found! G.viewed_sleeve = " .. tprint(G.viewed_sleeve, 2))
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

function G.UIDEF.sleeve_description(sleeve_key, minw)
    minw = minw or 5.5
    local sleeve_center = CardSleeves.Sleeve:get_obj(sleeve_key)
    local ret_nodes = {}
    local sleeve_name = ""
    if sleeve_center then
        sleeve_name = sleeve_center:get_name()
        sleeve_center:generate_ui({}, nil, ret_nodes, nil, {name = {}})
    else
        sleeve_name = "ERROR"
        ret_nodes = {
            {{
                config = { scale= 0.32, colour = G.C.BLACK, text= localize('sleeve_not_found_error'), },
                n= 1,
            }},
            {{
                config = { scale= 0.32, colour = G.C.BLACK, text= "(DEBUG: key = '" .. tprint(G.viewed_sleeve) .. "')", },
                n= 1,
            }},
        }
    end

    local desc_t = {}
    for _, v in ipairs(ret_nodes) do
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
                    { n = G.UIT.T, config = { text = sleeve_name, scale = 0.35, colour = G.C.WHITE } }
                }
            },
            {
                n = G.UIT.R,
                config = { align = "cm", padding = 0.03, colour = G.C.WHITE, r = 0.1, minh = 1, minw = minw },
                nodes = desc_t
            }
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
    local current_sleeve_index = 1
    local sleeve_options = {}
    for i, v in pairs(G.P_CENTER_POOLS.Sleeve) do
        -- if v.unlocked then
        table.insert(sleeve_options, v)
        if v.key == G.viewed_sleeve then
            current_sleeve_index = i
        end
    end

    return {
        n = G.UIT.ROOT,
        config = { align = "tm", colour = G.C.CLEAR, minw = 8.5 },
        nodes = { _type == 'Continue' and middle or create_option_cycle({
            options = sleeve_options,
            opt_callback = 'change_sleeve',
            current_option = current_sleeve_index,
            colour = G.C.RED,
            w = 6,
            mid = middle
        }) }
    }
end

function G.UIDEF.viewed_sleeve_option()
    G.viewed_sleeve = G.viewed_sleeve or "sleeve_casl_none"

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
                    G.UIDEF.sleeve_description(G.viewed_sleeve, 5.5)
                }
            }
        }
    }
end

function G.UIDEF.current_sleeve(_scale)
    -- create a UI node with sleeve image, sleeve name, description, and mod badges
    _scale = _scale or 1
    local sleeve_center = CardSleeves.Sleeve:get_obj(G.GAME.selected_sleeve or "sleeve_casl_none")
    local sleeve_sprite = create_sleeve_sprite(0, 0, _scale*1.5, _scale*(95/71)*1.5, sleeve_center)
    sleeve_sprite.states.drag.can = false
    local mod_badges = create_sleeve_badges(sleeve_center)
    return {
        n = G.UIT.ROOT,
        config = { align = "cm", colour = G.C.BLACK, r = 0.1, padding = 0.1},
        nodes = {
            {
                n = G.UIT.R,
                config = { align = "cm", colour = G.C.BLACK, padding = 0.1, minw = 4 },
                nodes = {
                    { n = G.UIT.O, config = { colour = G.C.BLACK, object = sleeve_sprite, hover = true, can_collide = false } },
                    { n = G.UIT.T, config = { text = "Sleeve", scale = _scale / 2, colour = G.C.WHITE } }
                }
            },
            {
                n = G.UIT.R,
                config = { align = "cm", padding = 0.1 },
                nodes = {
                    G.UIDEF.sleeve_description(G.GAME.selected_sleeve, 5.5)
                }
            },
            mod_badges
        }
    }
end

function create_UIBox_sleeve_unlock(sleeve_center)
    local area = CardArea(G.ROOM.T.x - 100, G.ROOM.T.h, 1.2*G.CARD_W, 1.2*G.CARD_H,
                          {card_limit = 52, type = 'deck', highlight_limit = 0})
    local card = Card(G.ROOM.T.x + 0.2*G.ROOM.T.w/2,G.ROOM.T.h, G.CARD_W*1.2, G.CARD_H*1.2, pseudorandom_element(G.P_CARDS), G.P_CENTERS.c_base, {viewed_back = true})
    card.sprite_facing = 'back'
    card.facing = 'back'
    area:emplace(card)
    local sleeve_card = create_sleeve_card(area, sleeve_center)
    replace_sleeve_sprite(sleeve_card, sleeve_center, {x=0, y=0.2})
    area:emplace(sleeve_card)

    local sleeve_criteria = {}
    localize{type = 'descriptions', set = "Sleeve", key = 'sleeve_locked', nodes = sleeve_criteria, vars = sleeve_center:locked_loc_vars().vars, default_col = G.C.WHITE, shadow = true}
    local sleeve_criteria_cols = {}
    for k, v in ipairs(sleeve_criteria) do
        if k > 1 then sleeve_criteria_cols[#sleeve_criteria_cols+1] = {n=G.UIT.C, config={align = "cm", padding = 0, minw = 0.1}, nodes={}} end
        sleeve_criteria_cols[#sleeve_criteria_cols+1] = {n=G.UIT.C, config={align = "cm", padding = 0}, nodes=v}
    end

    local sleeve_description = {}
    sleeve_center:generate_ui({}, nil, sleeve_description, nil, {name = {}})
    local sleeve_description_cols = {}
    for _, v in ipairs(sleeve_description) do
        sleeve_description_cols[#sleeve_description_cols + 1] = { n = G.UIT.R, config = { align = "cm"}, nodes = v }
    end

    local t = create_UIBox_generic_options({ back_label = localize('b_continue'), no_pip = true, snap_back = true, back_func = 'continue_unlock', minw = 7, contents = {
      {n=G.UIT.R, config={align = "cm", padding = 0}, nodes={
        {n=G.UIT.O, config={object = DynaText({string = {{string = localize{type = 'name_text', set = 'Sleeve', key = sleeve_center.key}, suffix = ' '..localize('k_unlocked_ex'), outer_colour = G.C.UI.TEXT_LIGHT}}, colours = {G.C.BLUE},shadow = true, rotate = true, float = true, scale = 0.7, pop_in = 0.1})}}
      }},
      {n=G.UIT.R, config={align = "cm", padding = 0}, nodes=sleeve_criteria_cols},
      {n=G.UIT.R, config={align = "cm", padding = 0.2, colour = G.C.BLACK, r = 0.2}, nodes={
          {n=G.UIT.C, config={align = "cm", padding = 0}, nodes={
            {n=G.UIT.O, config={object = area}}
          }},
          {n=G.UIT.C, config={align = "cm", r = 0.2, colour = G.C.WHITE, emboss = 0.05, padding = 0.2, minw = 4}, nodes={
            {n=G.UIT.R, config={align = "cm", padding = 0}, nodes=sleeve_description_cols}
          }}
        }}
    }})
    return t
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

local old_uidef_run_info = G.UIDEF.run_info
function G.UIDEF.run_info(...)
    is_in_run_info_tab = true
    local output = old_uidef_run_info(...)
    is_in_run_info_tab = false
    return output
end

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
        G.viewed_sleeve = "sleeve_casl_none"
        if G.SAVED_GAME ~= nil then
            G.viewed_sleeve = saved_game.GAME.selected_sleeve or G.viewed_sleeve
        end
        table.insert(output.nodes, 2,
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
        G.viewed_sleeve = G.PROFILES[G.SETTINGS.profile].MEMORY.sleeve or G.viewed_sleeve or "sleeve_casl_none"
        table.insert(output.nodes, 2,
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
    else
        print_warning("Unexpected value for _type = " .. tprint(_type))
    end
    return output
end

local old_uidef_challenge_description_tab = G.UIDEF.challenge_description_tab
function G.UIDEF.challenge_description_tab(args)
    local output = old_uidef_challenge_description_tab(args)

    if args._tab == "Rules" then
        local challenge = G.CHALLENGES[args._id]
        if challenge.sleeve then
            local sleeve_center = CardSleeves.Sleeve:get_obj(challenge.sleeve)
            local UI_node = {
                n = G.UIT.R,
                config = {align = "cl", maxw = 3.5},
                nodes = localize {
                    type = "text",
                    key = "ch_m_sleeve",
                    vars = {sleeve_center:get_name()},
                    default_col = G.C.L_BLACK
                }
            }
            table.insert(output.nodes[1].nodes[2].nodes[2].nodes, 1, UI_node)  -- I love UI stuff
        end
    end

    return output
end

local old_uidef_view_deck = G.UIDEF.view_deck
function G.UIDEF.view_deck(...)
    local output = old_uidef_view_deck(...)

    local config_in_view_deck = CardSleeves.config.sleeve_info_location == 1 or CardSleeves.config.sleeve_info_location == 3
    if G.GAME.selected_sleeve and G.GAME.selected_sleeve ~= "sleeve_casl_none" and config_in_view_deck then
        -- combine suit_tallies into 1x4 if only 2x2, to save on horizontal space (yes this looks bad with mods that add suits)
        local base_cards_area = output.nodes[2].nodes[1].nodes[1].nodes[2]
        local suit_tallies = base_cards_area.nodes[3].nodes
        if #suit_tallies <= 2 and not base_cards_area.nodes[5] then
            for _, suit_element in ipairs(base_cards_area.nodes[4].nodes) do
                table.insert(suit_tallies, suit_element)
            end
            table.remove(base_cards_area.nodes, 4)
        end

        -- insert sleeve description UI element
        local minw = 2.5
        local UI_node = {
            n = G.UIT.R,
            config = {align = "cm", r = 0.1, colour = G.C.L_BLACK, emboss = 0.05, padding = 0.05},
            nodes = {
                {
                    n = G.UIT.R,
                    config = {align = "cm", r = 0.1, minw = minw, maxw = 4, minh = 1, colour = G.C.CLEAR},
                    nodes = {
                        G.UIDEF.sleeve_description(G.GAME.selected_sleeve, minw),
                    }
                }
            }
        }
        table.insert(output.nodes[2].nodes[1].nodes[1].nodes, 2, UI_node)
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
    local sleeve_center = CardSleeves.Sleeve:get_obj(G.viewed_sleeve)
    if sleeve_center == nil or not sleeve_center:is_unlocked() then
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    end
end

local old_FUNCS_your_collection = G.FUNCS.your_collection
function G.FUNCS.your_collection(...)
    in_collection = true
    return old_FUNCS_your_collection(...)
end
local old_buildAdditionsTab = buildAdditionsTab
function buildAdditionsTab(...)
    -- from steamodded
    in_collection = true
    return old_buildAdditionsTab(...)
end
local old_FUNCS_exit_overlay_menu = G.FUNCS.exit_overlay_menu
function G.FUNCS.exit_overlay_menu(...)
    in_collection = false
    return old_FUNCS_exit_overlay_menu(...)
end
local old_FUNCS_mods_button = G.FUNCS.mods_button
function G.FUNCS.mods_button(...)
    -- from steamodded
    in_collection = false
    return old_FUNCS_mods_button(...)
end

local old_Game_start_run = Game.start_run
function Game:start_run(args)
    -- because G.GAME.challenge only gets defined _after_ `:init_game_object`
    game_args = args
    old_Game_start_run(self, args)
end

local old_Game_init_game_object = Game.init_game_object
function Game:init_game_object(...)
    local output = old_Game_init_game_object(self, ...)
    local is_challenge = game_args.challenge and game_args.challenge.id  -- HouseRules compat
    if not is_challenge then
        output.selected_sleeve = G.viewed_sleeve or "sleeve_casl_none"
    elseif is_challenge and game_args.challenge.sleeve then
        output.selected_sleeve = game_args.challenge.sleeve
    else
        output.selected_sleeve = "sleeve_casl_none"
    end
    return output
end

local old_Back_apply_to_run = Back.apply_to_run
function Back:apply_to_run(...)
    local sleeve_center = CardSleeves.Sleeve:get_obj(G.GAME.selected_sleeve or "sleeve_casl_none")
    old_Back_apply_to_run(self, ...)
    sleeve_center:apply()
end

local old_Back_trigger_effect = Back.trigger_effect
function Back:trigger_effect(args)
    local sleeve_center = CardSleeves.Sleeve:get_obj(G.GAME.selected_sleeve or "sleeve_casl_none")
    local new_chips, new_mult

    new_chips, new_mult = old_Back_trigger_effect(self, args)
    args.chips, args.mult = new_chips or args.chips, new_mult or args.mult

    new_chips, new_mult = sleeve_center:trigger_effect(args)
    args.chips, args.mult = new_chips or args.chips, new_mult or args.mult

    return args.chips, args.mult
end

local old_CardArea_draw = CardArea.draw
function CardArea:draw(...)
    if not self.states.visible then return end
    if G.VIEWING_DECK and (self==G.deck or self==G.hand or self==G.play) then return end

    local sleeve_center = CardSleeves.Sleeve:get_obj(G.GAME.selected_sleeve)
    local draw_sleeve = self == G.deck and sleeve_center

    if draw_sleeve and self.children["view_deck"] then
        -- prevent drawing the "view deck" button, we'll draw it ourselves later
        local old_view_deck_draw = self.children.view_deck.draw
        self.children.view_deck.draw = function() end
    end

    old_CardArea_draw(self, ...)

    if draw_sleeve then
        local x, y = 999999999, -1
        local x2, height = -1, -1
        for i, card in pairs(self.cards) do
            local index_is_drawn = i == 1 or i%(self.config.thin_draw or 9) == 0 or i == #self.cards
            local is_stationary = not card.states.drag.is and card.velocity.x < 0.01 and card.velocity.y < 0.01
            if index_is_drawn and card.states.visible and is_stationary then
                x = math.min(x, card.T.x)
                y = math.max(y, card.T.y)
                x2 = math.max(x2, card.T.x + card.T.w)
                height = math.max(height, card.T.h)
            end
        end
        local width = x2 - x
        x = x > 1000000 and self.T.x + 0.1 or x
        y = (y < 0 and self.T.y or y) + (CardSleeves.config.adjust_deck_alignment and 0.05 or -0.05)
        width = width <= 0 and self.T.w - 0.2 or width + 0.01
        height = height <= 0 and self.T.h or height
        if self.sleeve_sprite == nil then
            self.sleeve_sprite = create_sleeve_sprite(x, y, width, height, sleeve_center)
        else
            -- update x, y, width, height
            self.sleeve_sprite.T.x = x
            self.sleeve_sprite.T.y = y
            self.sleeve_sprite.T.w = width
            self.sleeve_sprite.T.h = height
        end
        self.sleeve_sprite:draw()
        if self.children["view_deck"] and G.deck_preview or self.states.collide.is or (G.buttons and G.buttons.states.collide.is and G.CONTROLLER.HID.controller) then
            -- restore draw behavior of "view deck" so it can be drawn on top of sleeve sprite
            self.children.view_deck.draw = old_view_deck_draw
            self.children.view_deck:draw()
        end
    end
end

local old_CardArea_align_cards = CardArea.align_cards
function CardArea:align_cards(...)
    old_CardArea_align_cards(self, ...)

    if (self == G.hand or self == G.deck or self == G.discard or self == G.play) and G.view_deck and G.view_deck[1] and G.view_deck[1].cards then return end
    if self.config.type == 'deck' and self == G.deck and CardSleeves.config.adjust_deck_alignment then
        local total_cards = 0
        for _, card in ipairs(self.cards) do
            if card.states.visible and not card.states.drag.is then
                -- cartomancer compatibility
                total_cards = total_cards + 1
            end
        end
        for k, card in ipairs(self.cards) do
            if card.states.visible and not card.states.drag.is then
                card.T.x = self.T.x + 0.1 + 0.0002*(total_cards-k)
                card.T.y = self.T.y - 0.2 - 0.0005*(total_cards-k)
            end
        end
    end
end

local old_Controller_snap_to = Controller.snap_to
function Controller:snap_to(args)
    -- hooking into this might not be a good idea tbh, but I don't have a controller to test it, so...
    -- TODO: see if there's a better way to do this (Game:update_shop?)
    local in_shop_load = G["shop"] and args["node"] and
                         (args.node == G.shop:get_UIE_by_ID('next_round_button') or
                          args.node["area"] and args.node.area["config"] and args.node.area.config.type == "shop")
    if in_shop_load then
        -- shop has been loaded/rerolled/etc
        local sleeve_center = CardSleeves.Sleeve:get_obj(G.GAME.selected_sleeve) or CardSleeves.Sleeve:get_obj("sleeve_casl_none")
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
    local output = old_Card_set_base(self, card, initial)

    if not is_in_run_info_tab then
        local sleeve_center = CardSleeves.Sleeve:get_obj(G.GAME.selected_sleeve) or CardSleeves.Sleeve:get_obj("sleeve_casl_none")
        if initial then
            sleeve_center:trigger_effect{context = {create_card = true, card = self}}
        elseif not initial and self.playing_card then
            sleeve_center:trigger_effect{context = {modify_playing_card = true, card = self}}
        end
    end

    return output
end

local old_Card_use_consumable = Card.use_consumeable
function Card:use_consumeable(...)
    local sleeve_center = CardSleeves.Sleeve:get_obj(G.GAME.selected_sleeve or "sleeve_casl_none")
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

local old_create_tabs = create_tabs
function create_tabs(args)
    local sleeve_exists = G.GAME.selected_sleeve and G.GAME.selected_sleeve ~= "sleeve_casl_none"
    local config_in_run_info = CardSleeves.config.sleeve_info_location == 2 or CardSleeves.config.sleeve_info_location == 3
    if args["tabs"] and is_in_run_info_tab and sleeve_exists and config_in_run_info then
        table.insert(args.tabs, 4, {
            label = "Sleeve",
            tab_definition_function = G.UIDEF.current_sleeve
        })
    end

    return old_create_tabs(args)
end

create_UIBox_arcana_pack = booster_pack_size_fix_wrapper(create_UIBox_arcana_pack)
create_UIBox_spectral_pack = booster_pack_size_fix_wrapper(create_UIBox_spectral_pack)
create_UIBox_standard_pack = booster_pack_size_fix_wrapper(create_UIBox_standard_pack)
create_UIBox_buffoon_pack = booster_pack_size_fix_wrapper(create_UIBox_buffoon_pack)
create_UIBox_celestial_pack = booster_pack_size_fix_wrapper(create_UIBox_celestial_pack)

local old_create_UIBox_card_unlock = create_UIBox_card_unlock
function create_UIBox_card_unlock(card_center)
    if card_center.set == "Sleeve" and not CardSleeves.config.allow_any_sleeve_selection and not G.PROFILES[G.SETTINGS.profile].all_unlocked then
        return create_UIBox_sleeve_unlock(card_center)
    end
    return old_create_UIBox_card_unlock(card_center)
end

local old_smods_save_unlocks = SMODS.SAVE_UNLOCKS
function SMODS.SAVE_UNLOCKS(...)
    old_smods_save_unlocks(...)
end

local old_set_deck_win = set_deck_win
function set_deck_win(...)
    -- basically set_sleeve_win()
    if G.GAME.selected_sleeve then
        local sleeve_center = CardSleeves.Sleeve:get_obj(G.GAME.selected_sleeve)
        if sleeve_center then
            set_sleeve_usage()
            local sleeve_usage = G.PROFILES[G.SETTINGS.profile].sleeve_usage[G.GAME.selected_sleeve]
            sleeve_usage.wins_by_key[SMODS.stake_from_index(G.GAME.stake)] = (sleeve_usage.wins_by_key[SMODS.stake_from_index(G.GAME.stake)] or 0) + 1
            local applied =  SMODS.build_stake_chain(G.P_STAKES[SMODS.stake_from_index(G.GAME.stake)]) or {}
            for i, _ in ipairs(G.P_CENTER_POOLS.Stake) do
                if applied[i] then
                    sleeve_usage.wins_by_key[SMODS.stake_from_index(G.GAME.stake)] = sleeve_usage.wins_by_key[SMODS.stake_from_index(G.GAME.stake)] or 1
                end
            end
            G.PROFILES[G.SETTINGS.profile].sleeve_usage[G.GAME.selected_sleeve] = sleeve_usage
        end
    end
    old_set_deck_win(...)  -- at end to let old func call `G:save_settings()`
end

local old_set_deck_loss = set_deck_loss
function set_deck_loss(...)
    -- basically set_sleeve_loss()
    if G.GAME.selected_sleeve then
        local sleeve_center = CardSleeves.Sleeve:get_obj(G.GAME.selected_sleeve)
        if sleeve_center then
            set_sleeve_usage()
            local sleeve_usage = G.PROFILES[G.SETTINGS.profile].sleeve_usage[G.GAME.selected_sleeve]
            if not sleeve_usage then
                sleeve_usage = {count = 1, wins = {}, losses = {}, wins_by_key = {}, losses_by_key = {}}
            end
            sleeve_usage.losses_by_key[SMODS.stake_from_index(G.GAME.stake)] = (sleeve_usage.losses_by_key[SMODS.stake_from_index(G.GAME.stake)] or 0) + 1
            G.PROFILES[G.SETTINGS.profile].sleeve_usage[G.GAME.selected_sleeve] = sleeve_usage
        end
    end
    old_set_deck_loss(...)  -- at end to let old func call `G:save_settings()`
end

-- GALDUR (1.1.1) COMPATIBILITY

local function populate_info_queue(set, key)
    -- direct copy from galdur, but I need it outside of galdur
    local info_queue = {}
    local loc_target = G.localization.descriptions[set][key]
    for _, lines in ipairs(loc_target.text_parsed) do
        for _, part in ipairs(lines) do
            if part.control.T then info_queue[#info_queue+1] = G.P_CENTERS[part.control.T] or G.P_TAGS[part.control.T] end
        end
    end
    return info_queue
end

local function generate_sleeve_card_areas()
    if sleeve_card_areas then
        for i=1, #sleeve_card_areas do
            for j=1, #G.I.CARDAREA do
                if sleeve_card_areas[i] == G.I.CARDAREA[j] then
                    table.remove(G.I.CARDAREA, j)
                    sleeve_card_areas[i] = nil
                end
            end
        end
    end
    sleeve_card_areas = {}
    for i=1, sleeve_count_page do
        sleeve_card_areas[i] = CardArea(G.ROOM.T.x + 0.2*G.ROOM.T.w/2,G.ROOM.T.h, 0.95*G.CARD_W, 0.945*G.CARD_H,
        {card_limit = 5, type = 'deck', highlight_limit = 0, deck_height = 0.35, thin_draw = 1, index = i})
    end
end

local function populate_sleeve_card_areas(page)
    local count = 1 + (page - 1) * sleeve_count_page
    for i=1, sleeve_count_page do
        if count > #G.P_CENTER_POOLS.Sleeve then
            return
        end
        local area = sleeve_card_areas[i]
        if not area.cards then
            area.cards = {}
        end
        local card_number = 10
        if Galdur and Galdur.config.reduce then
            card_number = 1
        end
        local selected_deck_center = in_collection and G.P_CENTERS.b_red or Galdur.run_setup.choices.deck.effect.center
        for index = 1, card_number do
            local card = Card(area.T.x, area.T.y, area.T.w, area.T.h, selected_deck_center, selected_deck_center,
                {galdur_back = Back(selected_deck_center)})
            card.sprite_facing = 'back'
            card.facing = 'back'
            card.children.back = Sprite(card.T.x, card.T.y, card.T.w, card.T.h, G.ASSET_ATLAS[selected_deck_center.atlas or 'centers'], selected_deck_center.pos)
            card.children.back.states.hover = card.states.hover
            card.children.back.states.click = card.states.click
            card.children.back.states.drag = card.states.drag
            card.children.back.states.collide.can = false
            card.children.back:set_role({major = card, role_type = 'Glued', draw_major = card})
            area:emplace(card)
            if index == card_number then
                card.sticker = get_deck_win_sticker(selected_deck_center)
            end
        end
        local card = create_sleeve_card(area, G.P_CENTER_POOLS.Sleeve[count])
        card.params["sleeve_select"] = i
        card.sleeve_select_position = {page = page, count = i}
        replace_sleeve_sprite(card, G.P_CENTER_POOLS.Sleeve[count])
        area:emplace(card)
        count = count + 1
    end
end

local function generate_sleeve_card_areas_ui()
    local deck_ui_element = {}
    local count = 1
    for _ = 1, sleeve_count_vertical do
        local row = {n = G.UIT.R, config = {colour = G.C.LIGHT, padding = 0.075}, nodes = {}}  -- padding is this because size of cardareas isn't 100% => same total
        for _ = 1, sleeve_count_horizontal do
            if count > #G.P_CENTER_POOLS.Sleeve then return end
            table.insert(row.nodes, {n = G.UIT.O, config = {object = sleeve_card_areas[count], r = 0.1, id = "sleeve_select_"..count}})
            count = count + 1
        end
        table.insert(deck_ui_element, row)
    end

    populate_sleeve_card_areas(1)

    return {n=G.UIT.R, config={align = "cm", minh = 3.3, minw = 5, colour = G.C.BLACK, padding = 0.15, r = 0.1, emboss = 0.05}, nodes=deck_ui_element}
end

local function clean_sleeve_areas()
    if not sleeve_card_areas then return end
    for j = 1, #sleeve_card_areas do
        if sleeve_card_areas[j].cards then
            remove_all(sleeve_card_areas[j].cards)
            sleeve_card_areas[j].cards = {}
        end
    end
end

local function create_sleeve_page_cycle()
    local options = {}
    local cycle
    if #G.P_CENTER_POOLS.Sleeve > sleeve_count_page then
        local total_pages = math.ceil(#G.P_CENTER_POOLS.Sleeve / sleeve_count_page)
        for i=1, total_pages do
            table.insert(options, localize('k_page')..' '..i..' / '..total_pages)
        end
        cycle = create_option_cycle({
            options = options,
            w = 4.5,
            cycle_shoulders = true,
            opt_callback = 'change_sleeve_page',
            focus_args = { snap_to = true, nav = 'wide' },
            current_option = 1,
            colour = G.C.RED,
            no_pips = true
        })
    end
    return {n = G.UIT.R, config = {align = "cm"}, nodes = {cycle}}
end

local old_Card_hover = Card.hover
function Card:hover()
    if self.params.sleeve_select and (not self.states.drag.is or G.CONTROLLER.HID.touch) and not self.no_ui and not G.debug_tooltip_toggle then
        self:juice_up(0.05, 0.03)
        play_sound('paper1', math.random()*0.2 + 0.9, 0.35)
        if self.children.alert and not self.config.center.alerted then
            self.config.center.alerted = true
            G:save_progress()
        end

        local col = self.params.deck_preview and G.UIT.C or G.UIT.R
        local info_col = self.params.deck_preview and G.UIT.R or G.UIT.C
        local sleeve = self.config.center
        local sleeve_localvars = sleeve["loc_vars"] and sleeve:loc_vars()
        local sleeve_localkey = sleeve_localvars and sleeve_localvars.key or sleeve.key

        local status, result = pcall(populate_info_queue, 'Sleeve', sleeve_localkey)
        if not status then
            -- exception
            if result:find("'loc_target'") then
                error("Incorrect or missing localization for '" .. sleeve_localkey .. "'")
            end
            populate_info_queue('Sleeve', sleeve_localkey)
        end
        local info_queue = result
        local tooltips = {}
        for _, center in pairs(info_queue) do
            local desc = generate_card_ui(center, {main = {},info = {},type = {},name = 'done'}, nil, center.set, nil)
            tooltips[#tooltips + 1] =
            {n=info_col, config={align = "tm"}, nodes={
                {n=G.UIT.R, config={align = "cm", colour = lighten(G.C.JOKER_GREY, 0.5), r = 0.1, padding = 0.05, emboss = 0.05}, nodes={
                info_tip_from_rows(desc.info[1], desc.info[1].name),
                }}
            }}
        end

        local ret_nodes = {}
        sleeve:generate_ui({}, nil, ret_nodes, nil, {name = {}})
        local desc_t = {}
        for _, v in ipairs(ret_nodes) do
            desc_t[#desc_t + 1] = { n = G.UIT.R, config = { align = "cm"}, nodes = v }
        end
        local sleeve_name_colour = G.C.WHITE
        if sleeve_localkey ~= sleeve.key then
            sleeve_name_colour = G.C.DARK_EDITION
        end
        self.config.h_popup = {n=G.UIT.C, config={align = "cm", padding=0.1}, nodes={
            (self.params.sleeve_select > sleeve_count_horizontal and {n=col, config={align='cm', padding=0.1}, nodes = tooltips} or {n=G.UIT.R}),
            {n=col, config={align=(self.params.deck_preview and 'bm' or 'cm')}, nodes = {
                {n=G.UIT.C, config={align = "cm", minh = 1.5, r = 0.1, colour = G.C.L_BLACK, padding = 0.1, outline=1}, nodes={
                    {n=G.UIT.R, config={align = "cm", r = 0.1, minw = 3, maxw = 4, minh = 0.4}, nodes={
                        {n=G.UIT.O, config={object = UIBox{definition =
                            {n=G.UIT.ROOT, config={align = "cm", colour = G.C.CLEAR}, nodes={
                                {n=G.UIT.O, config={object = DynaText({string = sleeve:get_name(), maxw = 4, colours = {sleeve_name_colour}, shadow = true, bump = true, scale = 0.5, pop_in = 0, silent = true})}},
                            }},
                        config = {offset = {x=0,y=0}, align = 'cm'}}}
                        },
                    }},
                    {n=G.UIT.R, config={align = "cm", colour = G.C.WHITE, minh = 1.3, maxh = 3, minw = 3, maxw = 4, r = 0.1}, nodes={
                        {n=G.UIT.R, config = { align = "cm", padding = 0.03, colour = G.C.WHITE, r = 0.1}, nodes = desc_t }
                    }},
                    create_sleeve_badges(sleeve)
                }}
            }},
            (self.params.sleeve_select <= sleeve_count_horizontal and {n=col, config={align=(self.params.deck_preview and 'bm' or 'cm'), padding=0.1}, nodes = tooltips} or {n=G.UIT.R})

        }}
        self.config.h_popup_config = self:align_h_popup()

        Node.hover(self)
    else
        old_Card_hover(self)
    end
end

G.FUNCS.change_sleeve_page = function(args)
    clean_sleeve_areas()
    populate_sleeve_card_areas(args.cycle_config.current_option)
end

G.FUNCS.cycle_options = function(args)
    -- G.FUNCS.cycle_update from Galdur
    args = args or {}
    if args.cycle_config and args.cycle_config.ref_table and args.cycle_config.ref_value then
        args.cycle_config.ref_table[args.cycle_config.ref_value] = args.to_key
    end
end

if Galdur then
    local min_galdur_version = '1.1.4'
    local galdur_page_index = 2  -- page that our sleeves appear on - only start drawing information from this page onward

    local function set_sleeve_text(sleeve_center)
        -- sets deck name to sleeve name in Galdur's deck preview
        local texts = split_string_2(sleeve_center:get_name())
        if Galdur.deck_preview_texts then
            Galdur.deck_preview_texts.deck_preview_1 = texts[1]
            Galdur.deck_preview_texts.deck_preview_2 = texts[2]
            for i=1, 2 do
                local dyna_text_uinode = G.OVERLAY_MENU:get_UIE_by_ID('deck_name_'..i)
                if dyna_text_uinode then
                    dyna_text_uinode.config.object.scale = 0.7/math.max(1, string.len(Galdur.deck_preview_texts['deck_preview_'..i])/8)
                    dyna_text_uinode.config.object.config.non_recalc = true
                end
            end
        end
    end

    local old_Galdur_populate_deck_preview = Galdur.populate_deck_preview
    function Galdur.populate_deck_preview(_deck, silent)
        old_Galdur_populate_deck_preview(_deck, silent)

        if CardSleeves.Sleeve:get_obj(G.viewed_sleeve) and Galdur.run_setup.selected_deck_area and Galdur.run_setup.current_page >= galdur_page_index then
            local area, sleeve_center = Galdur.run_setup.selected_deck_area, CardSleeves.Sleeve:get_obj(G.viewed_sleeve)
            local card = create_sleeve_card(area, sleeve_center)
            card.params["sleeve_select"] = 1
            card.params["deck_preview"] = true
            replace_sleeve_sprite(card, sleeve_center)
            area:emplace(card)
        end
    end

    local old_Galdur_display_deck_preview = Galdur.display_deck_preview
    function Galdur.display_deck_preview()
        if CardSleeves.Sleeve:get_obj(G.viewed_sleeve) and Galdur.run_setup.current_page >= galdur_page_index then
            set_sleeve_text(CardSleeves.Sleeve:get_obj(G.viewed_sleeve))
        end
        return old_Galdur_display_deck_preview()
    end

    local function set_new_sleeve(sleeve_center, silent)
        -- visual only - use G.FUNCS.change_sleeve to change the actual value
        G.E_MANAGER:clear_queue('galdur')
        insert_sleeve_card(Galdur.run_setup.selected_deck_area, sleeve_center)
        local _, card = find_sleeve_card(Galdur.run_setup.selected_deck_area)
        if card then
            card.params["sleeve_select"] = 1
            card.params["deck_preview"] = true
        end

        set_sleeve_text(sleeve_center)
    end

    local old_quick_start = G.FUNCS.quick_start
    function G.FUNCS.quick_start()
        if G.viewed_sleeve == nil or CardSleeves.Sleeve:get_obj(G.viewed_sleeve) == nil then
            -- make sure G.viewed_sleeve actually has a sensible definition
            G.FUNCS.change_sleeve{to_key=1}
        end
        return old_quick_start()
    end

    G.FUNCS.random_sleeve = function()
        local random
        local random_sleeve_opts = {}
        for i=1, #G.P_CENTER_POOLS.Sleeve do
            if G.P_CENTER_POOLS.Sleeve[i]:is_unlocked() then
                random_sleeve_opts[#random_sleeve_opts + 1] = i
            end
        end
        while not random do
            random = pseudorandom_element(random_sleeve_opts, pseudoseed(os.time()))
            if G.P_CENTER_POOLS.Sleeve[random].key == G.viewed_sleeve and #random_sleeve_opts > 1 then
                random = false
            end
        end
        play_sound('whoosh1', math.random()*0.2 + 0.9, 0.35)
        G.FUNCS.change_sleeve{to_key = random}
        set_new_sleeve(G.P_CENTER_POOLS.Sleeve[random])
    end

    local function galdur_sleeve_page()
        if SMODS.Mods.galdur.version >= min_galdur_version then
            generate_sleeve_card_areas()
            Galdur.include_deck_preview()

            local deck_preview = Galdur.display_deck_preview()
            deck_preview.nodes[#deck_preview.nodes+1] = {n = G.UIT.R, config={align = 'cm', padding = 0.15}, nodes = {
                {n=G.UIT.R, config = {maxw = 2.5, minw = 2.5, minh = 0.8, r = 0.1, hover = true, ref_value = 1, button = 'random_sleeve', colour = Galdur.badge_colour, align = "cm", emboss = 0.1}, nodes = {
                    {n=G.UIT.T, config={text = localize("gald_random_sleeve"), scale = 0.4, colour = G.C.WHITE}}
                }}
            }}

            return
            {n=G.UIT.ROOT, config={align = "tm", minh = 3.8, colour = G.C.CLEAR, padding=0.1}, nodes={
                {n=G.UIT.C, config = {padding = 0.15}, nodes ={
                    generate_sleeve_card_areas_ui(),
                    create_sleeve_page_cycle(),
                }},
                deck_preview
            }}
        else
            return
            {n=G.UIT.ROOT, config={align = "tm", minh = 3.8, colour = G.C.CLEAR, padding=0.1}, nodes={
                {n=G.UIT.R, config = {align = "cm", padding = 0.15}, nodes ={
                    {n=G.UIT.C, nodes = {
                        {n=G.UIT.T, config={text = "Update Galdur to v" .. min_galdur_version .. " or higher!", scale = 0.8, colour = G.C.WHITE}},
                    }}
                }},
                {n=G.UIT.R, config = {align = "cm", padding = 0.15}, nodes ={
                    {n=G.UIT.C, nodes = {
                        {n=G.UIT.T, config={text = "(detected version: v" .. tprint(SMODS.Mods.galdur.version) .. ")", scale = 0.5, colour = G.C.WHITE}}
                    }}
                }}
            }}
        end
    end

    local function quick_start_text()
        if not G.viewed_sleeve then
            G.viewed_sleeve = G.PROFILES[G.SETTINGS.profile].MEMORY.sleeve or "sleeve_casl_none"
        end
        local sleeve_center = CardSleeves.Sleeve:get_obj(G.viewed_sleeve)
        if sleeve_center then
            return sleeve_center:get_name()
        else
            return "ERROR"
        end
    end

    local old_Card_click = Card.click
    function Card:click()
        if self.sleeve_select_position and self.config.center:is_unlocked() and not in_collection then
            local nr = (self.sleeve_select_position.page - 1) * sleeve_count_page + self.sleeve_select_position.count
            G.FUNCS.change_sleeve{to_key = nr}
            set_new_sleeve(self.config.center)
        else
            old_Card_click(self)
        end
    end

    Galdur.add_new_page({
        definition = galdur_sleeve_page,
        name = 'gald_sleeves',
        page = galdur_page_index,
        quick_start_text = quick_start_text,
        confirm = clean_sleeve_areas
    })
end

-- DIVVY'S PREVIEW (2.4) COMPATIBILITY

if DV and DV.SIM then
    local old_DV_SIM_simulate_deck_effects = DV.SIM.simulate_deck_effects
    function DV.SIM.simulate_deck_effects()
        old_DV_SIM_simulate_deck_effects()
        if G.GAME.selected_sleeve == "sleeve_casl_plasma" then
            local function plasma(data)
                local sum = data.chips + data.mult
                local half_sum = math.floor(sum/2)
                data.chips = mod_chips(half_sum)
                data.mult = mod_mult(half_sum)
            end
            plasma(DV.SIM.running.min)
            plasma(DV.SIM.running.exact)
            plasma(DV.SIM.running.max)
        end
    end
end

-- SMODS UI funcs (additions, config, collection)

SMODS.current_mod.config_tab = function()
    local scale = 5/6
    return {n=G.UIT.ROOT, config = {align = "cl", minh = G.ROOM.T.h*0.25, padding = 0.0, r = 0.1, colour = G.C.GREY}, nodes = {
        {n = G.UIT.R, config = { padding = 0.05 }, nodes = {
            {n = G.UIT.C, config = { minw = G.ROOM.T.w*0.25, padding = 0.05 }, nodes = {
                create_toggle{ label = localize("adjust_deck_alignment"), info = localize("adjust_deck_alignment_desc"), active_colour = CardSleeves.badge_colour, ref_table = CardSleeves.config, ref_value = "adjust_deck_alignment" },
                {n=G.UIT.R, config={minh=0.25}},
                create_option_cycle{
                    label = localize("sleeve_info_location"),
                    info = localize("sleeve_info_location_desc"),
                    options = localize("sleeve_info_location_options"),
                    current_option = CardSleeves.config.sleeve_info_location,
                    colour = CardSleeves.badge_colour,
                    w = 4.5,
                    text_scale = 0.4,
                    scale = scale,
                    ref_table = CardSleeves.config,
                    ref_value = "sleeve_info_location",
                    opt_callback = 'cycle_options',
                }
            }},
            {n = G.UIT.C, config = { align = "cr", minw = G.ROOM.T.w*0.25, padding = 0.05 }, nodes = {
                create_toggle{ label = localize("allow_any_sleeve_selection"), info = localize("allow_any_sleeve_selection_desc"), active_colour = CardSleeves.badge_colour, ref_table = CardSleeves.config, ref_value = "allow_any_sleeve_selection" },
            }},
        }}
    }}
end

SMODS.current_mod.custom_collection_tabs = function()
    local tally = 0
    for _, v in pairs(G.P_CENTER_POOLS['Sleeve']) do
        if v:is_unlocked() then
            tally = tally + 1
        end
    end
    return { UIBox_button {
        count = {tally = tally, of = #G.P_CENTER_POOLS['Sleeve']},
        button = 'your_collection_sleeves', label = {localize("k_sleeve")}, minw = 5, id = 'your_collection_sleeves'
    }}
end

local function create_UI_alt_description()
    return {n = G.UIT.R, config = {align = "cm"}, nodes = {
        {n=G.UIT.O, config={object = DynaText({string = localize("sleeve_unique_effect_desc"), shadow = true, bump = true, scale = 0.5, pop_in = 0, silent = true})}},
    }}
end

local function create_UIBox_sleeves()
    generate_sleeve_card_areas()
    local sleeve_pages = {n=G.UIT.C, config = {padding = 0.15}, nodes ={
        generate_sleeve_card_areas_ui(),
        create_sleeve_page_cycle(),
        create_UI_alt_description(),
    }}
    return create_UIBox_generic_options{
        back_func = G.ACTIVE_MOD_UI and "openModUI_"..G.ACTIVE_MOD_UI.id or 'your_collection',
        contents = {sleeve_pages}
    }
end

G.FUNCS.your_collection_sleeves = function()
	G.SETTINGS.paused = true
	G.FUNCS.overlay_menu{
	  definition = create_UIBox_sleeves(),
	}
end

print_trace("Trace logging level enabled")
print_info("CardSleeves v" .. SMODS.Mods.CardSleeves.version .. " loaded~!")

----------------------------------------------
------------MOD CODE END----------------------
