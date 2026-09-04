---@meta

---@class DefaultSleeveConfigs
---@field voucher? string Key of a voucher to automatically redeem (Magic and Nebula decks)
---@field vouchers? string[] Key of vouchers to automatically redeem (Zodiac deck)
---@field hands? number Additional hands per round (Blue Deck)
---@field discards? number Additional discards per round (Red Deck)
---@field consumables? string[] Keys of consumeables to start with (Magic and Ghost decks)
---@field dollars? number Additional dollars
---@field remove_faces? boolean Ban faces, Abandoned Deck style
---@field spectral_rate? number Set a rate for Spectrals to appear in shop, Ghost Deck style
---@field reroll_discount? number Discount on starting cost of rerolls
---@field edition? string Key of an edition to apply to `edition_count` random playing cards
---@field edition_count? number Number of random playing cards to apply `edition` to
---@field randomize_rank_suit? boolean Randomize starting deck (Erratic Deck)
---@field joker_slot? number Modify starting Joker slots (Black and Painted decks)
---@field hand_size? number Modify starting hand size (Painted deck)
---@field ante_scaling? number Increase blind size scaling per Ante (green and purple stakes)
---@field consumable_slot? number Modify starting consumeable slots (Nebula deck)
---@field no_interest? boolean Disable interest mechanic (Green Deck)
---@field extra_hand_bonus? number Grant more $ for unused hands at end of round (Green Deck)
---@field extra_discard_bonus? number Grant $ for unused discards at end of round (Green Deck)

---@class SleeveUnlockConditions
---@field deck string Key of the deck to unlock this sleeve
---@field stake string Key of the stake to unlock this sleeve

---@class CardSleeves.Sleeve:SMODS.Center
---@field super? SMODS.Center|table Parent class. 
---@field __call? fun(self: CardSleeves.Sleeve|table, o: CardSleeves.Sleeve|table): nil|table|CardSleeves.Sleeve
---@field config? DefaultSleeveConfigs|table Holds default values. Default `apply` method has handling for common values stored here.
---@field unlocked? boolean Set to `false` to require unlocking this sleeve before playing
---@field check_for_unlock? fun(self:CardSleeves.Sleeve, args:table):boolean|nil Conditions under which to unlock this sleeve. If not defined, defaults to winning `unlock_condition.deck` on `unlock_condition.stake`.
---@field unlock_condition? SleeveUnlockConditions|table Stores data for unlock conditions. If `check_for_unlock` is not defined, must contain a `deck` and `stake` field to define default unlock condition.
---@field apply? fun(self:CardSleeves.Sleeve, sleeve:Card) Performs actions upon starting a run. Overriding this will also override default application of values in `config`!
---@field calculate? fun(self:CardSleeves.Sleeve, sleeve:Card, context:CalcContext):table?, boolean? Defines behavior during gameplay.
---
---@deprecated
---@field trigger_effect? function Deprecated, use a calculate method instead
---@overload fun(self:CardSleeves.Sleeve):CardSleeves.Sleeve
CardSleeves.Sleeve = setmetatable({}, {
    __call = function(self)
        return self
    end
})