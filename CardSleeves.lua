--- CardSleeves main code file

--[[

KNOWN ISSUES/TODO IDEAS:

* TODO:
** split into seperate files once a mod manager exists
** Up min SMODS to 0423a to get SMODS.DrawStep or 0525b for deck preview pages & hand limit API

* ISSUES:
** What if locked sleeves in challenge?
** Minor Issue: Tags for booster packs have wrong description when using double zodiac/ghost

* API:
** add optional shaders

* IDEAS:
** See if people want to select their own sleeves in challenges instead of adhering to the challenge?
** How about optional 2nd sleeve that only shows up for the respective deck (e.g. 2 unique sleeves for a deck???)
** See if people want some unique/custom sleeves by CardSleeves?
** See if people want a nerfed/balanced version of sleeves?

--]]

--#region GLOBALS (in this mod)
CardSleeves = SMODS.current_mod

-- not perfect, but works well enough afaik
local in_collection = false
local starting_run = false
local is_in_run_info_tab = false
local game_args = {}

local sleeve_count_horizontal = 6
local sleeve_count_vertical = 2
local sleeve_count_page = sleeve_count_horizontal * sleeve_count_vertical
local sleeve_card_areas = {}
--#endregion

--#region DEBUG FUNCS
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
--#endregion

--#region LOCALIZATION
function SMODS.current_mod.process_loc_text()
    -- will crash the game if removed
    G.localization.descriptions.Sleeve = G.localization.descriptions.Sleeve or {}
end
--#endregion

--#region ATLAS
SMODS.Atlas {
    key = "sleeve_atlas",
    path = "sleeves.png",
    px = 73,
    py = 95
}

SMODS.Atlas {
    key = "modicon",
    path = "icon.png",
    px = 34,
    py = 34
}
--#endregion

--#region SLEEVE BASE CLASS & METHODS
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
    inject = function(self)
        if not self.unlocked and self.check_for_unlock then
            if self:check_for_unlock() then
                self.unlocked = true
            end
        end
        SMODS.Center.inject(self)
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
        G.E_MANAGER:add_event(Event({
            func = function()
                Card.apply_to_run(nil, G.P_CENTERS[self.config.voucher])
                return true
            end
        }))
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
            G.E_MANAGER:add_event(Event({
                func = function()
                    Card.apply_to_run(nil, G.P_CENTERS[v])
                    return true
                end
            }))
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
        G.GAME.modifiers.money_per_hand = (G.GAME.modifiers.money_per_hand or 0) + self.config.extra_hand_bonus
    end
    if self.config.extra_discard_bonus then
        G.GAME.modifiers.money_per_discard = (G.GAME.modifiers.money_per_discard or 0) + self.config.extra_discard_bonus
    end
end

function CardSleeves.Sleeve:trigger_effect(args)
    if not args then return end

    -- keep for compatibility reasons? (people incl me assuming this function exists)
end

function CardSleeves.Sleeve:locked_loc_vars(info_queue, card)
    if not self.unlock_condition then
        error("Please implement custom `locked_loc_vars` or define `unlock_condition` for Sleeve " .. self.key)
    elseif not self.unlock_condition.deck or not self.unlock_condition.stake then
        error("Please implement custom `locked_loc_vars` or define `unlock_condition.deck` and `unlock_condition.stake` for Sleeve " .. self.key)
    end
    local deck_name = localize('k_unknown')
    if not G.P_CENTERS[self.unlock_condition.deck] then
        print_error("G.P_CENTERS[" .. tprint(self.unlock_condition.deck, 2) .. "] was not found!")
        deck_name = "[NOT FOUND]"
    elseif G.P_CENTERS[self.unlock_condition.deck].unlocked then
        deck_name = localize{type = "name_text", set = "Back", key = self.unlock_condition.deck}
    end
    local stake_key = type(self.unlock_condition.stake) == "number" and SMODS.stake_from_index(self.unlock_condition.stake) or self.unlock_condition.stake
    if type(self.unlock_condition.stake) == "number" then
        print_warning(("DEPRECATED usage of `%s.unlock_condition.stake` (from mod %s): please use the stake key (best guess is '%s') instead of index '%d'"):format(self.key, self.mod.id, stake_key, self.unlock_condition.stake))
    end
    local stake_name = localize{type = "name_text", set = "Stake", key = stake_key}
    local colours = G.C.GREY
    if stake_key ~= "stake_white" then
        colours = get_stake_col(SMODS.Stakes[stake_key].order)
    end
    local vars = { deck_name, stake_name, colours = {colours} }
    return { key = "sleeve_locked", vars = vars }
end

function CardSleeves.Sleeve:check_for_unlock(args)
    if not self.unlock_condition then
        error("Please implement custom `check_for_unlock` or define `unlock_condition` for Sleeve " .. self.key)
    elseif not self.unlock_condition.deck or not self.unlock_condition.stake then
        error("Please implement custom `check_for_unlock` or define `unlock_condition.deck` and `unlock_condition.stake` for Sleeve " .. self.key)
    end
    local deck_info = G.PROFILES[G.SETTINGS.profile] and G.PROFILES[G.SETTINGS.profile].deck_usage and G.PROFILES[G.SETTINGS.profile].deck_usage[self.unlock_condition.deck]
    local stake_key = type(self.unlock_condition.stake) == "number" and SMODS.stake_from_index(self.unlock_condition.stake) or self.unlock_condition.stake  -- best guess only
    if deck_info and deck_info.wins_by_key and deck_info.wins_by_key[stake_key] then
        return true
    end
end

function CardSleeves.Sleeve:is_unlocked()
    -- Checks self.unlocked, CardSleeves config, and basegame Unlock All. Use this to read self.unlocked unless you know what you're doing
    return self.unlocked or CardSleeves.config.allow_any_sleeve_selection or G.PROFILES[G.SETTINGS.profile].all_unlocked
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
        local res = {}
        if self.locked_loc_vars and type(self.locked_loc_vars) == 'function' then
            res = self:locked_loc_vars(info_queue, card) or {}
            target.key = res.key or target.key
            target.vars = res.vars or target.vars
        end
        if desc_nodes == full_UI_table.main and not full_UI_table.name then
            full_UI_table.name = self.set == 'Enhanced' and 'temp_value' or localize { type = 'name', set = target.set, key = res.name_key or target.key, nodes = full_UI_table.name, vars = res.name_vars or target.vars or {} }
        elseif desc_nodes ~= full_UI_table.main and not desc_nodes.name and self.set ~= 'Enhanced' then
            desc_nodes.name = localize{type = 'name_text', key = res.name_key or target.key, set = target.set }
        end
        localize(target)
    else
        return SMODS.Center.generate_ui(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    end
end

function CardSleeves.Sleeve.get_current_deck_key()
    if in_collection then
        -- bit hacky
        return "collection"
    elseif Galdur and Galdur.config.use and Galdur.run_setup.choices and Galdur.run_setup.choices.deck then
        return Galdur.run_setup.choices.deck.effect.center.key
    elseif G.GAME.viewed_back and G.GAME.viewed_back.effect then
        return G.GAME.viewed_back.effect.center.key
    elseif G.GAME.selected_back then
        return G.GAME.selected_back.effect.center.key
    end
    return "b_red"
end
--#endregion

--#region SLEEVE INSTANCES
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
    unlock_condition = { deck = "b_red", stake = "stake_red" },
    loc_vars = function(self)
        local key, vars
        if self.get_current_deck_key() == "b_red" then
            key = self.key .. "_alt"
            self.config = { discards = 1, hands = -1 }
            vars = { self.config.discards, self.config.hands }
        else
            key = self.key
            self.config = { discards = 1 }
            vars = { self.config.discards }
        end
        return { key = key, vars = vars }
    end,
}

CardSleeves.Sleeve {
    key = "blue",
    name = "Blue Sleeve",
    atlas = "sleeve_atlas",
    pos = { x = 1, y = 0 },
    unlocked = false,
    unlock_condition = { deck = "b_blue", stake = "stake_green" },
    loc_vars = function(self)
        local key, vars
        if self.get_current_deck_key() == "b_blue" then
            key = self.key .. "_alt"
            self.config = { hands = 1, discards = -1 }
            vars = { self.config.hands, self.config.discards }
        else
            key = self.key
            self.config = { hands = 1 }
            vars = { self.config.hands }
        end
        return { key = key, vars = vars }
    end,
}

CardSleeves.Sleeve {
    key = "yellow",
    name = "Yellow Sleeve",
    atlas = "sleeve_atlas",
    pos = { x = 2, y = 0 },
    unlocked = false,
    unlock_condition = { deck = "b_yellow", stake = "stake_green" },
    loc_vars = function(self)
        local key, vars
        if self.get_current_deck_key() == "b_yellow" then
            key = self.key .. "_alt"
            self.config = { voucher = "v_seed_money"}
            vars = { localize{type = 'name_text', key = self.config.voucher, set = 'Voucher'} }
        else
            key = self.key
            self.config = { dollars = 10}
            vars = { self.config.dollars }
        end
        return { key = key, vars = vars }
    end,
}

CardSleeves.Sleeve {
    key = "green",
    name = "Green Sleeve",
    atlas = "sleeve_atlas",
    pos = { x = 3, y = 0 },
    unlocked = false,
    unlock_condition = { deck = "b_green", stake = "stake_green" },
    loc_vars = function(self)
        local key, vars
        if self.get_current_deck_key() == "b_green" then
            key = self.key .. "_alt"
            self.config = { debt_bonus = 2 }
            local added_bankrupt = "?"
            if G.STAGE == G.STAGES.RUN then
                -- only calculate if we're in a run, otherwise it's bogus
                added_bankrupt = self.config.debt_bonus * (G.GAME.round_resets.discards + G.GAME.round_resets.hands)
            end
            vars = { self.config.debt_bonus, added_bankrupt }
        else
            key = self.key
            self.config = { extra_hand_bonus = 2, extra_discard_bonus = 1, no_interest = true }
            vars = { self.config.extra_hand_bonus, self.config.extra_discard_bonus, self.config.no_interest }
        end
        return { key = key, vars = vars }
    end,
    apply = function(self, sleeve)
        CardSleeves.Sleeve.apply(sleeve)
        if sleeve.config.debt_bonus then
            G.E_MANAGER:add_event(Event({
                trigger = "after",
                func = (function()
                    sleeve.config.added_bankrupt = sleeve.config.debt_bonus * (G.GAME.round_resets.discards + G.GAME.round_resets.hands)
                    G.GAME.bankrupt_at = G.GAME.bankrupt_at - sleeve.config.added_bankrupt
                    return true
                end)
            }))
        end
    end,
    calculate = function(self, sleeve, context)
        if sleeve.config.debt_bonus then
            if (context.end_of_round and not context.individual and not context.repetition) then
                if not sleeve.config.added_bankrupt then
                    sleeve.config.added_bankrupt = sleeve.config.debt_bonus * (G.GAME.round_resets.discards + G.GAME.round_resets.hands)
                end
                G.GAME.bankrupt_at = G.GAME.bankrupt_at + sleeve.config.added_bankrupt
                sleeve.config.added_bankrupt = sleeve.config.debt_bonus * (G.GAME.round_resets.discards + G.GAME.round_resets.hands)
                G.GAME.bankrupt_at = G.GAME.bankrupt_at - sleeve.config.added_bankrupt
            end
        end
    end
}

CardSleeves.Sleeve {
    key = "black",
    name = "Black Sleeve",
    atlas = "sleeve_atlas",
    pos = { x = 4, y = 0 },
    unlocked = false,
    unlock_condition = { deck = "b_black", stake = "stake_green" },
    loc_vars = function(self)
        local key, vars
        if self.get_current_deck_key() == "b_black" then
            key = self.key .. "_alt"
            self.config = { discards = -1, joker_slot = 1 }
            vars = { self.config.joker_slot, -self.config.discards }
        else
            key = self.key
            self.config = { hands = -1, joker_slot = 1 }
            vars = { self.config.joker_slot, -self.config.hands }
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
    unlock_condition = { deck = "b_magic", stake = "stake_black" },
    loc_vars = function(self)
        local key
        if self.get_current_deck_key() == "b_magic" then
            key = self.key .. "_alt"
            self.config = { voucher = "v_omen_globe" }
        else
            key = self.key
            self.config = { voucher = 'v_crystal_ball', consumables = { 'c_fool', 'c_fool' } }
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
    unlock_condition = { deck = "b_nebula", stake = "stake_black" },
    loc_vars = function(self)
        local key
        if self.get_current_deck_key() == "b_nebula" then
            key = self.key .. "_alt"
            self.config = { voucher = 'v_observatory' }
        else
            key = self.key
            self.config = { voucher = 'v_telescope', consumable_slot = -1 }
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
    unlock_condition = { deck = "b_ghost", stake = "stake_black" },
    loc_vars = function(self)
        local key
        local vars = {}
        if self.get_current_deck_key() == "b_ghost" then
            key = self.key .. "_alt"
            self.config = { spectral_rate = 4, spectral_more_options = 2 }
            vars[#vars+1] = self.config.spectral_more_options
        else
            key = self.key
            self.config = { spectral_rate = 2, consumables = { 'c_hex' } }
            vars[#vars+1] = localize{type = 'name_text', key = self.config.consumables[1], set = 'Tarot'}
        end
        return { key = key, vars = vars }
    end,
    calculate = function(self, sleeve, context)
        if context.create_card and context.card then
            local card = context.card
            local is_spectral_pack = card.ability.set == "Booster" and card.ability.name:find("Spectral")
            if is_spectral_pack and sleeve.config.spectral_more_options then
               card.ability.extra = card.ability.extra + sleeve.config.spectral_more_options
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
    unlock_condition = { deck = "b_abandoned", stake = "stake_black" },
    loc_vars = function(self)
        local key = self.key
        if self.get_current_deck_key() == "b_abandoned" then
            key = key .. "_alt"
            self.config = { prevent_faces = true }  -- prevent faces during entire run
        else
            key = self.key
            self.config = { remove_faces = true }  -- only removes faces at start of run
        end
        return { key = key }
    end,
    apply = function(self, sleeve)
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
    calculate = function(self, sleeve, context)
        if not sleeve.config.prevent_faces then
            return
        end
        if sleeve.skip_trigger_effect then
            return
        end
        if sleeve.allowed_card_centers == nil then
            sleeve:apply(sleeve)
        end

        -- handle Strength and Ouija
        local card = context.card
        local is_playing_card = card and (card.ability.set == "Default" or card.ability.set == "Enhanced") and card.config.card_key
        if context.before_use_consumable and card then
            if card.ability.name == 'Strength' then
                sleeve.in_strength = true
            elseif card.ability.name == "Ouija" then
                sleeve.in_ouija = true
            end
            if sleeve.in_strength and sleeve.in_ouija then
                print_warning("cannot be in both strength and ouija!")
            end
        elseif context.after_use_consumable then
            sleeve.in_strength = nil
            sleeve.in_ouija = nil
            sleeve.ouija_rank = nil
        elseif (context.create_card or context.modify_playing_card) and card and is_playing_card then
            if SMODS.Ranks[card.base.value].face then
                local initial = G.GAME.blind == nil or context.create_card
                if sleeve.in_strength then
                    local base_key = SMODS.Suits[card.base.suit].card_key .. "_" .. sleeve.get_rank_after_10()
                    card:set_base(G.P_CARDS[base_key], initial)
                elseif sleeve.in_ouija then
                    if sleeve.ouija_rank == nil then
                        local random_base = pseudorandom_element(sleeve.allowed_card_centers, pseudoseed("slv"))
                        local card_instance = Card(0, 0, 0, 0, random_base, G.P_CENTERS.c_base)
                        sleeve.ouija_rank = SMODS.Ranks[card_instance.base.value]
                        card_instance:remove()
                    end
                    local base_key = SMODS.Suits[card.base.suit].card_key .. "_" .. sleeve.ouija_rank.card_key
                    card:set_base(G.P_CARDS[base_key], initial)
                else
                    local random_base = pseudorandom_element(sleeve.allowed_card_centers, pseudoseed("slv"))
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
    unlock_condition = { deck = "b_checkered", stake = "stake_black" },
    loc_vars = function(self)
        local key
        if self.get_current_deck_key() == "b_checkered" then
            key = self.key .. "_alt"
            self.config = { force_suits = {["Clubs"] = "Spades", ["Diamonds"] = "Hearts"} }
        else
            key = self.key
            self.config = {}
        end
        return { key = key }
    end,
    calculate = function(self, sleeve, context)
        if not sleeve.config.force_suits then
            return
        end

        local card = context.card
        local is_playing_card = card and (card.ability.set == "Default" or card.ability.set == "Enhanced") and card.config.card_key
        if (context.create_card or context.modify_playing_card) and card and is_playing_card then
            for from_suit, to_suit in pairs(sleeve.config.force_suits) do
                if card.base.suit == from_suit then
                    local base = SMODS.Suits[to_suit].card_key .. "_" .. SMODS.Ranks[card.base.value].card_key
                    local initial = G.GAME.blind == nil or context.create_card
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
    unlock_condition = { deck = "b_zodiac", stake = "stake_blue" },
    loc_vars = function(self)
        local key
        local vars = {}
        if self.get_current_deck_key() == "b_zodiac" then
            key = self.key .. "_alt"
            self.config = { arcana_more_options = 2, celestial_more_options = 2 }
            vars[#vars+1] = self.config.arcana_more_options
            vars[#vars+1] = self.config.celestial_more_options
        else
            key = self.key
            self.config = { vouchers = {'v_tarot_merchant', 'v_planet_merchant', 'v_overstock_norm'} }
            for _, voucher in pairs(self.config.vouchers) do
                vars[#vars+1] = localize{type = 'name_text', key = voucher, set = 'Voucher'}
            end
        end
        return { key = key, vars = vars }
    end,
    calculate = function(self, sleeve, context)
        if context.create_card and context.card then
            local card = context.card
            local is_booster_pack = card.ability.set == "Booster"
            local is_arcana_pack = is_booster_pack and card.ability.name:find("Arcana")
            local is_celestial_pack = is_booster_pack and card.ability.name:find("Celestial")
            if is_arcana_pack and sleeve.config.arcana_more_options then
                card.ability.extra = card.ability.extra + sleeve.config.arcana_more_options
            elseif is_celestial_pack and sleeve.config.celestial_more_options then
                card.ability.extra = card.ability.extra + sleeve.config.celestial_more_options
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
    unlock_condition = { deck = "b_painted", stake = "stake_blue" },
    loc_vars = function(self)
        local key
        local vars = {}
        if self.get_current_deck_key() == "b_painted" then
            key = self.key .. "_alt"
            self.config = { selection_size = 1, joker_slot = -1 }
            vars = { self.config.selection_size, self.config.joker_slot }
        else
            key = self.key
            self.config = {hand_size = 2, joker_slot = -1}
            vars = { self.config.hand_size, self.config.joker_slot }
        end
        return { key = key, vars = vars }
    end,
    apply = function(self, sleeve)
        CardSleeves.Sleeve.apply(self)
        if sleeve.config.selection_size then
            G.E_MANAGER:add_event(Event({
                trigger = "after",
                func = (function()
                    G.hand.config.highlighted_limit = G.hand.config.highlighted_limit + sleeve.config.selection_size
                    if SMODS.change_play_limit and SMODS.change_discard_limit then
                        -- future proofing?
                        SMODS.change_play_limit(1)
                        SMODS.change_discard_limit(1)
                    end
                    return true
                end)
            }))
        end
    end
}

CardSleeves.Sleeve {
    key = "anaglyph",
    name = "Anaglyph Sleeve",
    atlas = "sleeve_atlas",
    pos = { x = 2, y = 2 },
    unlocked = false,
    unlock_condition = { deck = "b_anaglyph", stake = "stake_blue" },
    config = {},
    loc_vars = function(self)
        local key
        if self.get_current_deck_key() == "b_anaglyph" then
            key = self.key .. "_alt"
        else
            key = self.key
        end
        local vars = { localize{type = 'name_text', key = 'tag_double', set = 'Tag'} }
        return { key = key, vars = vars }
    end,
    calculate = function(self, sleeve, context)
        local add_double_tag_event = Event({
            func = (function()
                add_tag(Tag('tag_double'))
                play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
                play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
                return true
            end)
        })

        if context.round_eval then
            if sleeve.get_current_deck_key() == "b_anaglyph" and G.GAME.last_blind and not G.GAME.last_blind.boss then
                -- add double tag when stacking deck+sleeve on small/big blind
                G.E_MANAGER:add_event(add_double_tag_event)
            elseif sleeve.get_current_deck_key() ~= "b_anaglyph" and G.GAME.last_blind and G.GAME.last_blind.boss then
                -- add double tag like anaglyph deck does
                G.E_MANAGER:add_event(add_double_tag_event)
            end
        end
    end,
}

CardSleeves.Sleeve {
    key = "plasma",
    name = "Plasma Sleeve",
    atlas = "sleeve_atlas",
    pos = { x = 3, y = 2 },
    unlocked = false,
    unlock_condition = { deck = "b_plasma", stake = "stake_purple" },
    config = {ante_scaling = 2},
    loc_vars = function(self)
        local key
        if self.get_current_deck_key() == "b_plasma" then
            key = self.key .. "_alt"
        else
            key = self.key
        end
        local vars = { self.config.ante_scaling }
        return { key = key, vars = vars }
    end,
    calculate = function(self, sleeve, context)
        if self.get_current_deck_key() == "b_plasma" and (context.starting_shop or context.reroll_shop) then
            local hold = 0.6  -- how long to take to ease the costs, and how long to hold the player
            G.CONTROLLER.locks.shop_reroll = true  -- stop controller/mouse from doing anything
            if G.CONTROLLER:save_cardarea_focus('shop_jokers') then G.CONTROLLER.interrupt.focus = true end

            G.E_MANAGER:add_event(Event({
                delay = 0.01,  --  because tags don't immediately apply, sigh
                blockable = true,
                trigger = 'after',
                func = function()
                    local cardareas = {}
                    for _, obj in pairs(G) do
                        if type(obj) == "table" and obj["is"] and obj:is(CardArea) and obj.config.type == "shop" then
                            cardareas[#cardareas+1] = obj
                        end
                    end
                    local total_cost, total_items_for_sale = 0, 0
                    for _, cardarea in pairs(cardareas) do
                        for _, card in pairs(cardarea.cards) do
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
                    local avg_cost = math.floor((total_cost - 1) / total_items_for_sale)  -- make it always be in favour of the player
                    for _, cardarea in pairs(cardareas) do
                        for _, card in pairs(cardarea.cards) do
                            card.cost = math.max(card.cost, card.base_cost)
                            local mod = avg_cost - card.cost
                            --         table, value,  mod, floor, timer, not_blockable, delay, ease_type
                            ease_value(card,  "cost", mod, nil,   nil,   true,          hold,   "quad")
                            -- card.cost = avg_cost
                            -- card:set_cost()
                        end
                    end
                    G.E_MANAGER:add_event(Event({
                        func = (function()
                            play_sound('gong', 1.2, 0.2)
                            play_sound('gong', 1.2*1.5, 0.1)
                            play_sound('tarot1', 1.6, 0.8)
                            attention_text({
                                scale = 1.3,
                                colour = G.C.GOLD,
                                text = localize('k_balanced'),
                                hold = 1.5,
                                align = 'cm',
                                offset = {x = 0, y = -3.5},
                                major = G.play
                            })
                            return true
                        end)
                    }))
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = hold,
                        func = function()
                            -- allow player to buy cards again, ONLY after having eased prices
                            G.CONTROLLER.interrupt.focus = false
                            G.CONTROLLER.locks.shop_reroll = false
                            G.CONTROLLER:recall_cardarea_focus('shop_jokers')
                            return true
                        end
                    }))
                    return true
                end
            }))
        end

        if self.get_current_deck_key() ~= "b_plasma" and context.context == 'final_scoring_step' then
            -- cannot use `context.final_scoring_step` and `return {balance = true}` because it doesn't have the fancy animations
            -- copy-paste from plasma deck
            local tot = context.chips + context.mult
            context.chips = math.floor(tot/2)
            context.mult = math.floor(tot/2)
            update_hand_text({delay = 0}, {mult = context.mult, chips = context.chips})

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
            return context.chips, context.mult
        end
    end
}

CardSleeves.Sleeve {
    key = "erratic",
    name = "Erratic Sleeve",
    atlas = "sleeve_atlas",
    pos = { x = 4, y = 2 },
    unlocked = false,
    unlock_condition = { deck = "b_erratic", stake = "stake_orange" },
    config = {randomize_rank_suit = true},
    loc_vars = function(self)
        local key
        if self.get_current_deck_key() == "b_erratic" then
            key = self.key .. "_alt"
            self.config = {randomize_rank_suit = true, randomize_start = true, random_lb = 3, random_ub = 6}
        else
            key = self.key
            self.config = {randomize_rank_suit = true}
        end
        local vars = {}
        if self.config.randomize_start then
            vars[#vars+1] = self.config.random_lb
            vars[#vars+1] = self.config.random_ub
        end
        return { key = key, vars = vars }
    end,
    apply = function(self, sleeve)
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
--#endregion

--#region LOCAL FUNCS
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
    local fake_deck = {effect = {config = {}, center = {key = "fake", config = {}}, text_UI = {}, fake_deck = true}}
    local viewed_back = G.GAME.viewed_back ~= nil and fake_deck or false  -- cryptid compat
    local new_card = Card(area.T.x, area.T.y, area.T.w + 0.2, area.T.h, nil, sleeve_center or G.P_CENTERS.c_base, {playing_card = 11, viewed_back = viewed_back, galdur_selector = true, sleeve_card = true})
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
    offset = offset or {x=0, y=0.35}  -- any lower Y offset and sticker starts looking bad
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

local function deck_view_wrapper(func)
    -- insert sleeve info UI element if setting is enabled
    local function wrapper(...)
        local output = func(...) or {nodes = {G.OVERLAY_MENU:get_UIE_by_ID('suit_list')}}

        local config_in_view_deck = CardSleeves.config.sleeve_info_location == 1 or CardSleeves.config.sleeve_info_location == 3
        if G.GAME.selected_sleeve and G.GAME.selected_sleeve ~= "sleeve_casl_none" and config_in_view_deck then
            -- insert sleeve description UI element
            local minw, padding = 2.5, 0.05
            local UI_node = {
                n = G.UIT.R,
                config = {align = "cm", r = 0.1, colour = G.C.L_BLACK, emboss = 0.05},
                nodes = {
                    {
                        n = G.UIT.R,
                        config = {align = "cm", r = 0.1, minw = minw, maxw = 4, minh = 1, colour = G.C.WHITE},
                        nodes = {
                            G.UIDEF.sleeve_description(G.GAME.selected_sleeve, minw, padding),
                        }
                    }
                }
            }
            local base_cards_area, uibox

            local SMODS_view_deck_menu = output and output.nodes and output.nodes[1] and output.nodes[1].config and output.nodes[1].config.id == "suit_list"
            -- SMODS' view_deck UI menu since https://github.com/Steamodded/smods/pull/582  or  vanilla base implementation that is used in SMODS versions before PR 582

            if SMODS_view_deck_menu then
                uibox = output.nodes[1].config.object
                base_cards_area = uibox.definition.nodes[2].nodes[1].nodes[1].nodes[2]

                table.insert(uibox.definition.nodes[2].nodes[1].nodes[1].nodes, 2, UI_node)
            else
                base_cards_area = output.nodes[2].nodes[1].nodes[1].nodes[2]

                table.insert(output.nodes[2].nodes[1].nodes[1].nodes, 2, UI_node)
            end

            local suit_tallies = base_cards_area.nodes[3] and base_cards_area.nodes[3].nodes or {}
            -- combine suit_tallies into 1x4 if only 2x2, to save on vertical space
            if #suit_tallies <= 2 and base_cards_area.nodes[4] and not base_cards_area.nodes[5] then
                for _, suit_element in ipairs(base_cards_area.nodes[4].nodes) do
                    table.insert(suit_tallies, suit_element)
                end
                table.remove(base_cards_area.nodes, 4)
            end

            if SMODS_view_deck_menu and uibox then
                uibox:set_parent_child(uibox.definition, nil)
                uibox:recalculate()
            end
        end

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

local function get_sleeve_pool(mod_id)
    local sleeves = {}
    for _, sleeve in pairs(G.P_CENTER_POOLS.Sleeve) do
        if sleeve.mod.id == mod_id or mod_id == nil then
            sleeves[#sleeves+1] = sleeve
        end
    end
    return sleeves
end

local function get_sleeve_tally_of(mod_id)
    local tally, of = 0, 0
    for _, sleeve in pairs(get_sleeve_pool(mod_id)) do
        of = of + 1
        if sleeve:is_unlocked() then
            tally = tally + 1
        end
    end
    return {tally = tally, of = of}
end

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

local function populate_sleeve_card_areas(page, mod_id)
    local sleeve_pool = get_sleeve_pool(mod_id)
    local count = 1 + (page - 1) * sleeve_count_page
    for i=1, sleeve_count_page do
        if count > #sleeve_pool then
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
            card.children.back:remove()
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
        local card = create_sleeve_card(area, sleeve_pool[count])
        card.params["sleeve_select"] = i
        card.sleeve_select_position = {page = page, count = i}
        replace_sleeve_sprite(card, sleeve_pool[count])
        area:emplace(card)
        count = count + 1
    end
end

local function generate_sleeve_card_areas_ui(mod_id)
    local sleeve_pool = get_sleeve_pool(mod_id)
    local deck_ui_element = {}
    local count = 1
    for _ = 1, sleeve_count_vertical do
        local row = {n = G.UIT.R, config = {colour = G.C.LIGHT, padding = 0.075}, nodes = {}}  -- padding is this because size of cardareas isn't 100% => same total
        for _ = 1, sleeve_count_horizontal do
            if count > #sleeve_pool then break end
            table.insert(row.nodes, {n = G.UIT.O, config = {object = sleeve_card_areas[count], r = 0.1, id = "sleeve_select_"..count, focus_args = {snap_to = true}}})
            count = count + 1
        end
        table.insert(deck_ui_element, row)
    end

    populate_sleeve_card_areas(1, mod_id)

    return {n=G.UIT.R, config={align = "cm", minh = 3.3, minw = 5, colour = G.C.BLACK, padding = 0.15, r = 0.1, emboss = 0.05}, nodes=deck_ui_element}
end

local function clean_sleeve_areas()
    if not sleeve_card_areas then return end
    for j = #sleeve_card_areas, 1, -1 do
        if sleeve_card_areas[j].cards then
            remove_all(sleeve_card_areas[j].cards)
            sleeve_card_areas[j].cards = {}
        end
    end
end

local function create_sleeve_page_cycle(mod_id)
    local sleeve_pool = get_sleeve_pool(mod_id)
    local options = {}
    local cycle
    if #sleeve_pool > sleeve_count_page then
        local total_pages = math.ceil(#sleeve_pool / sleeve_count_page)
        for i=1, total_pages do
            options[i] = localize('k_page')..' '..i..' / '..total_pages
        end
        cycle = create_option_cycle({
            options = options,
            w = 4.5,
            opt_callback = 'change_sleeve_page',
            ref_table = { mod_id = mod_id },
            focus_args = { snap_to = true, nav = 'wide' },
            current_option = 1,
            colour = G.C.RED,
            no_pips = true
        })
    end
    return {n = G.UIT.R, config = {align = "cm"}, nodes = {cycle}}
end

local function create_sleeve_button(mod_id)
    -- creates the sleeve UIBox button in (collection/additions -> other) for given `mod_id`
    local count = get_sleeve_tally_of(mod_id)
    return UIBox_button {
        count = {tally = count.tally, of = count.of},
        button = 'your_collection_sleeves', label = {localize("k_sleeves")}, minw = 5, id = 'your_collection_sleeves'
    }
end

local function create_fake_sleeve(sleeve)
    -- shallow copy of given sleeve object
    -- this is so hacky I hate it
    local fake_sleeve = {}
    fake_sleeve.fake_sleeve = true
    for k, v in pairs(sleeve) do
        if k == "config" and type(v) == "table" then
            fake_sleeve[k] = {}
            for k2, v2 in pairs(v) do
                -- deep-ish copy of config table in case other modders do weird stuff with the config table
                fake_sleeve[k][k2] = v2
            end
        else
            fake_sleeve[k] = v
        end
    end
    setmetatable(fake_sleeve, getmetatable(sleeve))
    return fake_sleeve
end
--#endregion

--#region GLOBAL (used in UI) FUNCS
function G.FUNCS.change_sleeve(args)
    local sleeve_center = G.P_CENTER_POOLS.Sleeve[args.to_key]
    G.viewed_sleeve = sleeve_center.key
    G.PROFILES[G.SETTINGS.profile].MEMORY.sleeve = sleeve_center.key
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

G.FUNCS.change_sleeve_page = function(args)
    clean_sleeve_areas()
    populate_sleeve_card_areas(args.cycle_config.current_option, args.cycle_config.ref_table.mod_id)
end

G.FUNCS.casl_cycle_options = function(args)
    -- G.FUNCS.cycle_update from Galdur
    args = args or {}
    if args.cycle_config and args.cycle_config.ref_table and args.cycle_config.ref_value then
        args.cycle_config.ref_table[args.cycle_config.ref_value] = args.to_key
    end
end

function G.UIDEF.sleeve_description(sleeve_key, minw, padding)
    minw = minw or 5.5
    padding = padding or 0
    local sleeve_center = CardSleeves.Sleeve:get_obj(sleeve_key)
    local ret_nodes, full_UI_table = {}, {}
    local sleeve_name = ""
    if sleeve_center then
        sleeve_center.generate_ui(create_fake_sleeve(sleeve_center), {}, nil, ret_nodes, nil, full_UI_table)
        sleeve_name = full_UI_table.name or ret_nodes.name
    else
        sleeve_name = "ERROR"
        ret_nodes = {
            {{
                config = { scale= 0.32, colour = G.C.BLACK, text= localize('sleeve_not_found_error'), },
                n= 1,
            }},
            {{
                config = { scale= 0.32, colour = G.C.BLACK, text= "(DEBUG: key = '" .. tprint(sleeve_key) .. "')", },
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
        config = { align = "cm", padding = 0.047, r = 0.1, colour = G.C.L_BLACK },
        nodes = {
            {
                n = G.UIT.R,
                config = { align = "cm", padding = padding },
                nodes = {
                    { n = G.UIT.T, config = { text = sleeve_name, scale = 0.35, colour = G.C.WHITE } }
                }
            },
            {
                n = G.UIT.R,
                config = { align = "cm", colour = G.C.WHITE, r = 0.1, minh = 1, minw = minw, padding = padding },
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
        config = { align = "c", colour = G.C.BLACK, r = 0.1, minw = 7.23 },
        nodes = {
            {
                n = G.UIT.C,
                config = { align = "cm", padding = 0, minw = 1.44 },  -- the align l/r do nothing, praise minw
                nodes = {
                    { n = G.UIT.T, config = { text = localize('k_sleeve'), scale = 0.4, colour = G.C.L_BLACK } }
                }
            },
            {
                n = G.UIT.C,
                config = { padding = 0.1 },
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
    local sleeve_atlas = SMODS.Atlases[sleeve_center.atlas]
    local sleeve_size = {px = sleeve_atlas.px or 73, py = sleeve_atlas.py or 95}
    local sleeve_sprite = create_sleeve_sprite(0, 0, _scale*1.5, _scale*(sleeve_size.py/sleeve_size.px)*1.5, sleeve_center)
    sleeve_sprite.states.drag.can = false
    local mod_badges = create_sleeve_badges(sleeve_center)
    return {
        n = G.UIT.ROOT,
        config = { align = "cm", colour = G.C.BLACK, r = 0.1, padding = 0.15, emboss = 0.05},
        nodes = {
            {
                n = G.UIT.R,
                config = { align = "cm", colour = G.C.BLACK, padding = 0.1, minw = 4 },
                nodes = {
                    { n = G.UIT.O, config = { colour = G.C.BLACK, object = sleeve_sprite, hover = true, can_collide = false } },
                    { n = G.UIT.T, config = { text = localize('k_sleeve'), scale = _scale / 1.5, colour = G.C.WHITE, shadow = true } }
                }
            },
            {
                n = G.UIT.R,
                config = { align = "cm", colour = G.C.L_BLACK, r = 0.1, emboss = 0.05 },
                nodes = {
                    G.UIDEF.sleeve_description(G.GAME.selected_sleeve, 5.5, 0.1)
                }
            },
            mod_badges
        }
    }
end

function create_UIBox_sleeve_unlock(sleeve_center)
    local area = CardArea(G.ROOM.T.x - 100, G.ROOM.T.h, 1.2*G.CARD_W, 1.2*G.CARD_H, {card_limit = 52, type = 'deck', highlight_limit = 0})
    local card = Card(G.ROOM.T.x + 0.2*G.ROOM.T.w/2,G.ROOM.T.h, G.CARD_W*1.2, G.CARD_H*1.2, pseudorandom_element(G.P_CARDS), G.P_CENTERS.c_base, {viewed_back = true})
    card.sprite_facing = 'back'
    card.facing = 'back'
    area:emplace(card)
    local sleeve_card = create_sleeve_card(area, sleeve_center)
    replace_sleeve_sprite(sleeve_card, sleeve_center, {x=0, y=0.2})
    area:emplace(sleeve_card)

    local sleeve_criteria = {}
    local locked_loc_vars = sleeve_center:locked_loc_vars()
    localize{type = 'descriptions', set = "Sleeve", key = locked_loc_vars.key or 'sleeve_locked', nodes = sleeve_criteria, vars = locked_loc_vars.vars, default_col = G.C.WHITE, shadow = true}
    local sleeve_criteria_cols = {}
    for k, v in ipairs(sleeve_criteria) do
        if k > 1 then sleeve_criteria_cols[#sleeve_criteria_cols+1] = {n=G.UIT.C, config={align = "cm", padding = 0, minw = 0.1}, nodes={}} end
        sleeve_criteria_cols[#sleeve_criteria_cols+1] = {n=G.UIT.C, config={align = "cm", padding = 0}, nodes=v}
    end

    local sleeve_description = {}
    local old_get_current_deck_key = sleeve_center.get_current_deck_key
    sleeve_center.get_current_deck_key = function() return "" end  -- real hacky
    local loc_vars = sleeve_center.loc_vars and sleeve_center:loc_vars() or {}
    localize{type = 'descriptions', set = "Sleeve", key = sleeve_center.key, nodes = sleeve_description, vars = loc_vars.vars or {}}
    sleeve_center.get_current_deck_key = old_get_current_deck_key
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
--#endregion

--#region HOOKING / WRAPPING FUNCS
--[[
*List of functions we hook into and change its output or properties:
 (not a full list) (also see lovely patches!)
**G.UIDEF.run_setup_option
**G.UIDEF.view_deck
**G.FUNCS.can_start_run
**G.FUNCS.change_viewed_back
**Game:init_game_object
**Back:apply_to_run
**Back:trigger_effect
**CardArea:draw
**create_tabs
**Card:set_base
**Card:use_consumeable
**CardArea:unhighlight_all
**create_UIBox_arcana_pack
**create_UIBox_spectral_pack
**create_UIBox_standard_pack
**create_UIBox_buffoon_pack
**create_UIBox_celestial_pack
--]]

if SMODS.DrawStep and SMODS.version < "1.0.0~BETA-0423a" then
    local old_drawstep_back_sticker_func = SMODS.DrawSteps.back_sticker.func
    SMODS.DrawStep:take_ownership('back_sticker',
        {
            func = function(self)
                if self.params.sleeve_card and self.sticker and G.shared_stickers[self.sticker] then
                    G.shared_stickers[self.sticker].role.draw_major = self
                    local sticker_offset = self.sticker_offset or {}
                    G.shared_stickers[self.sticker]:draw_shader('dissolve', nil, nil, true, self.children.center, nil, self.sticker_rotation, sticker_offset.x, sticker_offset.y)
                    local stake = G.P_STAKES['stake_'..string.lower(self.sticker)] or {}
                    if stake.shiny then G.shared_stickers[self.sticker]:draw_shader('voucher', nil, self.ARGS.send_to_shader, true, self.children.center, nil, self.sticker_rotation, sticker_offset.x, sticker_offset.y) end
                else
                    old_drawstep_back_sticker_func(self)
                end
            end,
        }
    )
end

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

    in_collection = false

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
            if Galdur and Galdur.config.use and Galdur.run_setup.choices then
                Galdur.run_setup.choices.deck = G.GAME.viewed_back
            end
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
            local ret_nodes, full_UI_table = {}, {}
            sleeve_center.generate_ui(create_fake_sleeve(sleeve_center), {}, nil, ret_nodes, nil, full_UI_table)
            local sleeve_name = full_UI_table.name or ret_nodes.name
            local UI_node = {
                n = G.UIT.R,
                config = {align = "cl", maxw = 3.5},
                nodes = localize {
                    type = "text",
                    key = "ch_m_sleeve",
                    vars = {sleeve_name},
                    default_col = G.C.L_BLACK
                }
            }
            table.insert(output.nodes[1].nodes[2].nodes[2].nodes, 1, UI_node)  -- I love UI stuff
        end
    end

    return output
end

G.UIDEF.view_deck = deck_view_wrapper(G.UIDEF.view_deck)
if G.FUNCS.your_suits_page then
    G.FUNCS.your_suits_page = deck_view_wrapper(G.FUNCS.your_suits_page)
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

local old_FUNCS_start_setup_run = G.FUNCS.start_setup_run
function G.FUNCS.start_setup_run(e)
    starting_run = true

    old_FUNCS_start_setup_run(e)
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

    if G.STAGE == G.STAGES.RUN then
        if not starting_run then
            -- reset viewed back (galdur+vanilla) to selected back when closing the new run menu as to not confuse `get_current_deck_key`
            if Galdur and Galdur.config.use and Galdur.run_setup and Galdur.run_setup.choices then
                Galdur.run_setup.choices.deck = nil
            end
            G.GAME.viewed_back = nil
        end
        starting_run = false
    end

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
    in_collection = false

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
    old_Back_apply_to_run(self, ...)

    local sleeve_center = CardSleeves.Sleeve:get_obj(G.GAME.selected_sleeve or "sleeve_casl_none")
    if sleeve_center then
        if sleeve_center.loc_vars and type(sleeve_center.loc_vars) == "function" then
            sleeve_center:loc_vars()
        end
        sleeve_center:apply(sleeve_center)
    end

    starting_run = false
end

local old_Back_trigger_effect = Back.trigger_effect
function Back:trigger_effect(args)
    local sleeve_center = CardSleeves.Sleeve:get_obj(G.GAME.selected_sleeve or "sleeve_casl_none")

    local o = { old_Back_trigger_effect(self, args) }

    if args.context == "final_scoring_step" then
        -- for context.context == "final_scoring_step" (people should be using context.final_scoring_step)
        local new_chips, new_mult = unpack(o)
        args.chips, args.mult = new_chips or args.chips, new_mult or args.mult
        if type(sleeve_center.calculate) == "function" then
            new_chips, new_mult = sleeve_center:calculate(sleeve_center, args)
        elseif type(sleeve_center.trigger_effect) == "function" then
            -- support old deprecated trigger_effect
            new_chips, new_mult = sleeve_center:trigger_effect(args)
        end
        args.chips, args.mult = new_chips or args.chips, new_mult or args.mult
        return args.chips, args.mult
    elseif type(sleeve_center.calculate) == "function" and type(args.context) == "string" then
        -- basically only for context.context == "eval" (people should be using context.round_eval)
        local context = type(args.context) == "table" and args.context or args  -- bit hacky, though this shouldn't even have to be used?
        local effect = sleeve_center:calculate(sleeve_center, context)
        if effect then
            SMODS.calculate_effect(effect, G.deck.cards[1] or G.deck)
        end
    elseif type(sleeve_center.trigger_effect) == "function" then
        -- support old deprecated trigger_effect
        sleeve_center:trigger_effect(args)
    end

    return unpack(o)
end

local old_smods_get_card_areas = SMODS.get_card_areas
function SMODS.get_card_areas(_type, _context)
    local output = old_smods_get_card_areas(_type, _context)

    if _type == 'individual' then
        local sleeve_center = CardSleeves.Sleeve:get_obj(G.GAME.selected_sleeve or "sleeve_casl_none")
        if sleeve_center.calculate then
            local fake_sleeve = setmetatable({}, {
                -- almost "wrap" the sleeve
                __index = sleeve_center,
            })
            function fake_sleeve:calculate(context)
                -- Redirect to the actual sleeve:calculate method
                return sleeve_center:calculate(sleeve_center, context)
            end
            output[#output+1] = {
                object = fake_sleeve,
                scored_card = G.deck.cards[1] or G.deck,
            }
        end
    end

    return output
end

local old_CardArea_draw = CardArea.draw
function CardArea:draw(...)
    -- very invasive
    if not self.states.visible then return end
    if G.VIEWING_DECK and (self==G.deck or self==G.hand or self==G.play) then return end

    local sleeve_center = CardSleeves.Sleeve:get_obj(G.GAME.selected_sleeve)
    local draw_sleeve = self == G.deck and sleeve_center
    local old_view_deck_draw

    if draw_sleeve and self.children["view_deck"] then
        -- prevent drawing the "view deck" button, we'll draw it ourselves later
        old_view_deck_draw = self.children.view_deck.draw
        self.children.view_deck.draw = function() end
    end

    old_CardArea_draw(self, ...)

    if draw_sleeve then
        local compress_deck = CardSleeves.config.adjust_deck_alignment == true or CardSleeves.config.adjust_deck_alignment == 1 or CardSleeves.config.adjust_deck_alignment == 2
        local x, y = 999999999, -1
        local x2, height = -1, -1
        for i, card in pairs(self.cards) do
            local index_is_drawn = i == 1 or i%(self.config.thin_draw or 9) == 0 or i == #self.cards
            local is_stationary = not card.states.drag.is and math.abs(card.velocity.x) < 0.001 and math.abs(card.velocity.y) < 0.001
            if index_is_drawn and card.states.visible and is_stationary then
                x = math.min(x, card.T.x)
                y = math.max(y, card.T.y)
                x2 = math.max(x2, card.T.x + card.T.w)
                height = math.max(height, card.T.h)
            end
        end
        local width = x2 - x
        x = x > 1000000 and self.T.x + 0.1 or x - 0.03
        y = (y < 0 and self.T.y - 0.1 or y) + (compress_deck and 0.1 or -0.05)
        width = width <= 0 and self.T.w - 0.2 or width + 0.06
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
        if self.children["view_deck"] then
            -- restore draw behavior of "view deck"
            self.children.view_deck.draw = old_view_deck_draw
            if G.deck_preview or self.states.collide.is or (G.buttons and G.buttons.states.collide.is and G.CONTROLLER.HID.controller) then
                -- and don't forget to actually draw it when we need to
                self.children.view_deck:draw()
            end
        end
    end
end

local old_CardArea_align_cards = CardArea.align_cards
function CardArea:align_cards(...)
    old_CardArea_align_cards(self, ...)

    if (self == G.hand or self == G.deck or self == G.discard or self == G.play) and G.view_deck and G.view_deck[1] and G.view_deck[1].cards then return end
    local compress_deck = CardSleeves.config.adjust_deck_alignment == true or CardSleeves.config.adjust_deck_alignment == 1 or (CardSleeves.config.adjust_deck_alignment == 2 and G.GAME.selected_sleeve ~= "sleeve_casl_none")
    if self.config.type == 'deck' and self == G.deck and compress_deck then
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

local old_Card_set_base = Card.set_base
function Card:set_base(card, initial)
    local output = old_Card_set_base(self, card, initial)

    if not is_in_run_info_tab and self.ability then
        local sleeve_center = CardSleeves.Sleeve:get_obj(G.GAME.selected_sleeve or "sleeve_casl_none")
        local is_playing_card = (self.ability.set == "Default" or self.ability.set == "Enhanced") and self.config.card_key
        if initial then
            sleeve_center:trigger_effect{context = {create_card = true, card = self}}
            if type(sleeve_center.calculate) == "function" then sleeve_center:calculate(sleeve_center, {create_card = true, card = self}) end
        elseif not initial and is_playing_card then
            sleeve_center:trigger_effect{context = {modify_playing_card = true, card = self}}
            if type(sleeve_center.calculate) == "function" then sleeve_center:calculate(sleeve_center, {modify_playing_card = true, card = self}) end
        end
    end

    return output
end

local old_Card_use_consumable = Card.use_consumeable
function Card:use_consumeable(...)
    local sleeve_center = CardSleeves.Sleeve:get_obj(G.GAME.selected_sleeve or "sleeve_casl_none")
    sleeve_center:trigger_effect{context = {before_use_consumable = true, card = self}}
    if type(sleeve_center.calculate) == "function" then sleeve_center:calculate(sleeve_center, {before_use_consumable = true, card = self}) end

    local output = old_Card_use_consumable(self, ...)

    G.E_MANAGER:add_event(Event({
        delay = 0.01,  --  because consumables don't apply immediately
        blockable = true,
        trigger = 'after',
        func = function()
            sleeve_center:trigger_effect{context = {after_use_consumable = true}}
            if type(sleeve_center.calculate) == "function" then sleeve_center:calculate(sleeve_center, {after_use_consumable = true}) end
            return true
        end
    }))
    return output
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
        local sleeve_center = self.config.center
        local fake_sleeve_center = create_fake_sleeve(sleeve_center)
        local sleeve_localvars = sleeve_center["loc_vars"] and sleeve_center.loc_vars(fake_sleeve_center)
        local sleeve_localkey = sleeve_localvars and sleeve_localvars.key or sleeve_center.key

        local tooltips = {}
        if sleeve_center:is_unlocked() then
            local status, result = pcall(populate_info_queue, 'Sleeve', sleeve_localkey)
            if not status then
                -- exception
                if result:find("'loc_target'") then
                    error("Incorrect or missing localization for '" .. sleeve_localkey .. "'")
                end
                populate_info_queue('Sleeve', sleeve_localkey)
            end
            local info_queue = result
            for _, center in pairs(info_queue) do
                local desc = generate_card_ui(center, {main = {},info = {},type = {},name = 'done'}, nil, center.set, nil)
                tooltips[#tooltips + 1] =
                {n=info_col, config={align = self.params.sleeve_select > sleeve_count_horizontal and "bm" or "tm"}, nodes={
                    {n=G.UIT.R, config={align = "cm", colour = lighten(G.C.JOKER_GREY, 0.5), r = 0.1, padding = 0.05, emboss = 0.05}, nodes={
                    info_tip_from_rows(desc.info[1], desc.info[1].name),
                    }}
                }}
            end
        end

        local ret_nodes, full_UI_table = {}, {}
        sleeve_center.generate_ui(fake_sleeve_center, {}, nil, ret_nodes, nil, full_UI_table)
        local sleeve_name = full_UI_table.name or ret_nodes.name or "NAME ERROR"
        local desc_t = {}
        for _, v in ipairs(ret_nodes) do
            desc_t[#desc_t + 1] = { n = G.UIT.R, config = { align = "cm"}, nodes = v }
        end
        local sleeve_name_colour = G.C.WHITE
        if sleeve_localkey ~= sleeve_center.key then
            sleeve_name_colour = G.C.DARK_EDITION
        end
        self.config.h_popup = {n=G.UIT.C, config={align = "cm", padding=0.1}, nodes={
            (self.params.sleeve_select > sleeve_count_horizontal and {n=col, config={align='cm', padding=0.1}, nodes = tooltips} or {n=G.UIT.R}),
            {n=col, config={align=(self.params.deck_preview and 'bm' or 'cm')}, nodes = {
                {n=G.UIT.C, config={align = "cm", minh = 1.5, r = 0.1, colour = G.C.L_BLACK, padding = 0.1, outline=1}, nodes={
                    {n=G.UIT.R, config={align = "cm", r = 0.1, minw = 3, maxw = 4, minh = 0.4}, nodes={
                        {n=G.UIT.O, config={object = UIBox{definition =
                            {n=G.UIT.ROOT, config={align = "cm", colour = G.C.CLEAR}, nodes={
                                {n=G.UIT.O, config={object = DynaText({string = sleeve_name, maxw = 4, colours = {sleeve_name_colour}, shadow = true, bump = true, scale = 0.5, pop_in = 0, silent = true})}},
                            }},
                        config = {offset = {x=0,y=0}, align = 'cm'}}}
                        },
                    }},
                    {n=G.UIT.R, config={align = "cm", colour = G.C.WHITE, minh = 1.3, maxh = 3, minw = 3, maxw = 4, r = 0.1}, nodes={
                        {n=G.UIT.R, config = { align = "cm", padding = 0.03, colour = G.C.WHITE, r = 0.1}, nodes = desc_t }
                    }},
                    create_sleeve_badges(sleeve_center)
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

local old_Card_align_h_popup = Card.align_h_popup
function Card:align_h_popup()
    -- cannot use lovely patch since smods overwrites this
    local ret = old_Card_align_h_popup(self)

    if self.params.sleeve_card and not self.params.deck_preview and self.T.y < G.CARD_H*1.4 then
        -- default is G.CARD_H*0.8; we change the "flipping point" so the sleeves have their pop-up below them
        -- needs to be at least G.CARD_H*1.3 for bm when only one row of sleeves in collection
        ret.type = "bm"
    end

    return ret
end

local old_create_tabs = create_tabs
function create_tabs(args)
    local sleeve_exists = G.GAME.selected_sleeve and G.GAME.selected_sleeve ~= "sleeve_casl_none"
    local config_in_run_info = CardSleeves.config.sleeve_info_location == 2 or CardSleeves.config.sleeve_info_location == 3
    if args["tabs"] and is_in_run_info_tab and sleeve_exists and config_in_run_info then
        table.insert(args.tabs, 4, {
            label = localize('k_sleeve'),
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

local old_smods_create_UIBox_Other_GameObjects = create_UIBox_Other_GameObjects
function create_UIBox_Other_GameObjects()
    local mod_has_sleeves = false
    local old_mod_custom_collection_tabs
    if G.ACTIVE_MOD_UI and not G.ACTIVE_MOD_UI.prevent_autogenerate_sleeve_addition then
        -- `prevent_autogenerate_sleeve_addition` as opt-out, though I doubt anyone will want to use it
        local mod_id = G.ACTIVE_MOD_UI.id
        local mod_sleeve_count = get_sleeve_tally_of(mod_id)
        mod_has_sleeves = mod_id ~= CardSleeves.id and mod_sleeve_count.of > 0
        if mod_has_sleeves then
            old_mod_custom_collection_tabs = G.ACTIVE_MOD_UI.custom_collection_tabs
            G.ACTIVE_MOD_UI.custom_collection_tabs = function()
                local res = old_mod_custom_collection_tabs and old_mod_custom_collection_tabs() or {}
                res[#res+1] = create_sleeve_button(mod_id)
                return res
            end
        end
    end

    -- yes, we're hooking a smods function
    -- yes, I wish this was somehow built-in
    local res = old_smods_create_UIBox_Other_GameObjects()

    if mod_has_sleeves then
        G.ACTIVE_MOD_UI.custom_collection_tabs = old_mod_custom_collection_tabs
    end

    return res
end
--#endregion

--#region crossmod compat
if Galdur then
    -- GALDUR (1.1.4+) COMPATIBILITY
    local min_galdur_version = '1.1.4'
    local galdur_page_index = 2  -- page that our sleeves appear on - only start drawing information from this page onward
    local quick_start_sleeve = nil

    local function set_sleeve_text(sleeve_center)
        -- sets deck name to sleeve name in Galdur's deck preview
        local ret_nodes, full_UI_table = {}, {}
        sleeve_center.generate_ui(create_fake_sleeve(sleeve_center), {}, nil, ret_nodes, nil, full_UI_table)
        local sleeve_name = full_UI_table.name or ret_nodes.name
        local texts = split_string_2(sleeve_name)
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

    local function quick_start_text()
        if not quick_start_sleeve then
            quick_start_sleeve = G.viewed_sleeve or G.PROFILES[G.SETTINGS.profile].MEMORY.sleeve or "sleeve_casl_none"
        end
        local sleeve_center = CardSleeves.Sleeve:get_obj(quick_start_sleeve)
        if sleeve_center then
            local ret_nodes, full_UI_table = {}, {}
            sleeve_center.generate_ui(create_fake_sleeve(sleeve_center), {}, nil, ret_nodes, nil, full_UI_table)
            local sleeve_name = full_UI_table.name or ret_nodes.name
            return sleeve_name
        else
            return "ERROR"
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

    local old_Galdur_start_run = Galdur.start_run
    function Galdur.start_run(_quick_start)
        starting_run = true
        quick_start_sleeve = G.viewed_sleeve
        return old_Galdur_start_run(_quick_start)
    end

    local old_quick_start = G.FUNCS.quick_start
    function G.FUNCS.quick_start()
        -- gets called when pressing "last run" button in galdur
        G.viewed_sleeve = quick_start_sleeve
        if G.viewed_sleeve == nil or CardSleeves.Sleeve:get_obj(G.viewed_sleeve) == nil then
            -- make sure G.viewed_sleeve actually has a sensible definition
            G.FUNCS.change_sleeve{to_key=1}
        end
        return old_quick_start()
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
                {n=G.UIT.C, config = {maxw = 2.5, minw = 2.5, minh = 0.8, r = 0.1, hover = true, ref_value = 1, button = 'random_sleeve', colour = Galdur.badge_colour, align = "cm", emboss = 0.1}, nodes = {
                    {n=G.UIT.R, config = {align = 'cm'}, nodes = {{n=G.UIT.T, config={text = localize("gald_random_sleeve"), scale = 0.4, colour = G.C.WHITE}}}},
                    {n=G.UIT.R, config = {align = 'cm'}, nodes = {{n=G.UIT.C, config={func = 'set_button_pip', focus_args = { button = 'triggerright', set_button_pip = true, offset = {x=-0.2, y = 0.3}}}}}}
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

    local function confirm()
        clean_sleeve_areas()
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
        confirm = confirm
    })
end

if DV and DV.SIM then
    -- DIVVY'S PREVIEW (2.4) COMPATIBILITY
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
--#endregion

--#region SMODS UI funcs (additions, config, collection)
SMODS.current_mod.description_loc_vars = function()
    return { background_colour = G.C.CLEAR, text_colour = G.C.WHITE, scale = 1.2 }
end

SMODS.current_mod.config_tab = function()
    local scale = 5/6
    return {n=G.UIT.ROOT, config = {align = "cl", minh = G.ROOM.T.h*0.25, padding = 0.0, r = 0.1, colour = G.C.GREY}, nodes = {
        {n = G.UIT.R, config = { padding = 0.05 }, nodes = {
            {n = G.UIT.C, config = { minw = G.ROOM.T.w*0.25, padding = 0.05 }, nodes = {
                create_option_cycle{
                    label = localize("adjust_deck_alignment"),
                    info = localize("adjust_deck_alignment_desc"),
                    options = localize("adjust_deck_alignment_options"),
                    current_option = type(CardSleeves.config.adjust_deck_alignment) == "number" and CardSleeves.config.adjust_deck_alignment or (CardSleeves.config.adjust_deck_alignment and 1 or 3),
                    colour = CardSleeves.badge_colour,
                    w = 4.5,
                    text_scale = 0.4,
                    scale = scale,
                    ref_table = CardSleeves.config,
                    ref_value = "adjust_deck_alignment",
                    opt_callback = 'casl_cycle_options',
                },
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
                    opt_callback = 'casl_cycle_options',
                }
            }},
            {n = G.UIT.C, config = { align = "cr", minw = G.ROOM.T.w*0.25, padding = 0.05 }, nodes = {
                create_toggle{ label = localize("allow_any_sleeve_selection"), info = localize("allow_any_sleeve_selection_desc"), active_colour = CardSleeves.badge_colour, ref_table = CardSleeves.config, ref_value = "allow_any_sleeve_selection" },
            }},
        }}
    }}
end

SMODS.current_mod.custom_collection_tabs = function()
    return { create_sleeve_button(G.ACTIVE_MOD_UI and G.ACTIVE_MOD_UI.id or nil), }
end

local function create_UI_alt_description()
    return {n = G.UIT.R, config = {align = "cm"}, nodes = {
        {n=G.UIT.O, config={object = DynaText({string = localize("sleeve_unique_effect_desc"), shadow = true, bump = true, scale = 0.5, pop_in = 0, silent = true})}},
    }}
end

local function create_UIBox_sleeves(mod_id)
    generate_sleeve_card_areas()
    local sleeve_pages = {n=G.UIT.C, config = {padding = 0.15}, nodes ={
        generate_sleeve_card_areas_ui(mod_id),
        create_sleeve_page_cycle(mod_id),
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
        definition = create_UIBox_sleeves(G.ACTIVE_MOD_UI and G.ACTIVE_MOD_UI.id or nil),
	}
end
--#endregion

print_info("CardSleeves v" .. SMODS.Mods.CardSleeves.version .. " loaded~!")
