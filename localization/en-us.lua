return {
    descriptions = {
        Mod = {
            CardSleeves = {
                name = "Card Sleeves",
                text = {
                    "{s:1.3}Adds {s:1.3,C:attention}15{} {s:1.3,E:1,C:dark_edition}Sleeves{} {s:1.3}as modifier to decks.",
                    " ",
                    "Includes an API for other mods",
                    "to add their own Sleeves.",
                    " ",
                    "Programming and implementation by {C:blue}Larswijn{}.",
                    "Original idea and art by {C:red}Sable{}.",
                    " ",
                    "{s:1.1}See https://github.com/larswijn/CardSleeves for more information."
                }
            }
        },
        Sleeve = {
            sleeve_casl_none = {
                name = "No Sleeve",
                text = { "No sleeve modifiers" }
            },

            sleeve_locked = {
                name = "Locked",
                text = {
                    "Win a run with",
                    "{C:attention}#1#{} on",
                    "at least {V:1}#2#{} difficulty"
                }
            },

            sleeve_casl_red = {
                name = "Red Sleeve",
                text = G.localization.descriptions.Back["b_red"].text
            },
            sleeve_casl_red_alt = {
                name = "Red Sleeve",
                text = {
                    "{C:red}+#1#{} discard every round",
                    "",
                    "{C:blue}#2#{} hand every round"
                },
            },

            sleeve_casl_blue = {
                name = "Blue Sleeve",
                text = G.localization.descriptions.Back["b_blue"].text
            },
            sleeve_casl_blue_alt = {
                name = "Blue Sleeve",
                text = {
                    "{C:blue}+#1#{} hand every round",
                    "",
                    "{C:red}#2#{} discard every round"
                },
            },

            sleeve_casl_yellow = {
                name = "Yellow Sleeve",
                text = G.localization.descriptions.Back["b_yellow"].text
            },
            sleeve_casl_yellow_alt = {
                name = "Yellow Sleeve",
                text = {
                    "Start run with",
                    "{C:money,T:v_seed_money}#1#{} voucher"
                },
            },

            sleeve_casl_green = {
                name = "Green Sleeve",
                text = G.localization.descriptions.Back["b_green"].text
            },
            sleeve_casl_green_alt = {
                name = "Green Sleeve",
                text = {
                    "Can go up to",
                    "{C:red}-$#1#{} in debt for",
                    "every Hand and Discard",
                    "{C:inactive}(Currently {C:red}-$#2#{C:inactive})"
                }
            },

            sleeve_casl_black = {
                name = "Black Sleeve",
                text = G.localization.descriptions.Back["b_black"].text
            },
            sleeve_casl_black_alt = {
                name = "Black Sleeve",
                text = {
                    "{C:attention}+#1#{} Joker slot",
                    "",
                    "{C:red}-#2#{} discard",
                    "every round"
                }
            },

            sleeve_casl_magic = {
                name = "Magic Sleeve",
                text = G.localization.descriptions.Back["b_magic"].text
            },
            sleeve_casl_magic_alt = {
                name = "Magic Sleeve",
                text = {
                    "Start run with the",
                    "{C:tarot,T:v_omen_globe}#1#{} voucher",
                }
            },

            sleeve_casl_nebula = {
                name = "Nebula Sleeve",
                text = G.localization.descriptions.Back["b_nebula"].text
            },
            sleeve_casl_nebula_alt = {
                name = "Nebula Sleeve",
                text = {
                    "Start run with the",
                    "{C:planet,T:v_observatory}#1#{} voucher",
                    }
            },

            sleeve_casl_ghost = {
                name = "Ghost Sleeve",
                text = G.localization.descriptions.Back["b_ghost"].text
            },
            sleeve_casl_ghost_alt = {
                name = "Ghost Sleeve",
                text = {
                    "{C:spectral}Spectral{} cards appearance rate",
                    "in the shop doubles,",
                    "{C:spectral}Spectral Packs{} have {C:attention}#1#{}",
                    "extra options to choose from",
                }
            },

            sleeve_casl_abandoned = {
                name = "Abandoned Sleeve",
                text = G.localization.descriptions.Back["b_abandoned"].text
            },
            sleeve_casl_abandoned_alt = {
                name = "Abandoned Sleeve",
                text = {
                    "{C:attention}Face Cards{} will no longer",
                    "appear during the run"
                }
            },

            sleeve_casl_checkered = {
                name = "Checkered Sleeve",
                text = G.localization.descriptions.Back["b_checkered"].text
            },
            sleeve_casl_checkered_alt = {
                name = "Checkered Sleeve",
                text = {
                    "All {C:clubs}Club{} cards will get",
                    "converted to {C:spades}Spades{} and",
                    "all {C:diamonds}Diamond{} cards will get",
                    "converted to {C:hearts}Hearts{}",
                }
            },

            sleeve_casl_zodiac = {
                name = "Zodiac Sleeve",
                text = G.localization.descriptions.Back["b_zodiac"].text
            },
            sleeve_casl_zodiac_alt = {
                name = "Zodiac Sleeve",
                text = {
                    "{C:tarot}Tarot{} and {C:planet}Celestial{} Packs both have ",
                    "{C:attention}#1#{} extra options to choose from",
                }
            },

            sleeve_casl_painted = {
                name = "Painted Sleeve",
                text = G.localization.descriptions.Back["b_painted"].text
            },
            sleeve_casl_painted_alt = {
                name = "Painted Sleeve",
                text = {
                    "{C:attention}+#1#{} card selection limit,",
                    "{C:red}#2#{} Joker slot",
                }
            },

            sleeve_casl_anaglyph = {
                name = "Anaglyph Sleeve",
                text = G.localization.descriptions.Back["b_anaglyph"].text
            },
            sleeve_casl_anaglyph_alt = {
                name = "Anaglyph Sleeve",
                text = {
                    "After defeating each",
                    "{C:attention}Small{} or {C:attention}Big Blind{}, gain",
                    "a {C:attention,T:tag_double}#1#"
                }
            },

            sleeve_casl_plasma = {
                name = "Plasma Sleeve",
                text = G.localization.descriptions.Back["b_plasma"].text
            },
            sleeve_casl_plasma_alt = {
                name = "Plasma Sleeve",
                text = {
                    "Balance {C:money}price{} of all items",
                    "in the {C:attention}shop{}",
                }
            },

            sleeve_casl_erratic = {
                name = "Erratic Sleeve",
                text = G.localization.descriptions.Back["b_erratic"].text
            },
            sleeve_casl_erratic_alt = {
                name = "Erratic Sleeve",
                text = {
                    "Starting amount for {C:blue}hands{}, {C:red}discards{},",
                    "{C:money}dollars{}, and {C:attention}joker slots{}",
                    "are all randomized between {C:attention}#1#{} and {C:attention}#2#{}",
                }
            }
        }
    },
    misc = {
        dictionary = {
            k_sleeve = "Sleeve",
            k_sleeves = "Sleeves",
            gald_sleeves = "Select Sleeve",
            gald_random_sleeve = "Random Sleeve",
            sleeve_unique_effect_desc = "Some sleeves have unique effects when combined with specific decks",
            adjust_deck_alignment = "Stack deck pile",
            adjust_deck_alignment_desc = {
                "Stacks the cards in the deck pile",
                "much more closely while in a run to",
                "prevent sleeve stretching (visual only)"
            },
            adjust_deck_alignment_options = {
                "Always stack",
                "When using sleeve",
                "Never stack"
            },
            allow_any_sleeve_selection = "Unlock all sleeves",
            allow_any_sleeve_selection_desc = {
                "Allows any sleeve to be selected",
                "in the new run menu, as if unlocked"
            },
            sleeve_info_location = "Sleeve info location",
            sleeve_info_location_desc = {
                "In which menu the name and description",
                "of the currently used sleeve will be shown",
                "(visual only)"
            },
            sleeve_info_location_options = {
                "Only in deck view",
                "Only in run info",
                "Show in both",
                "Hide sleeve info"
            },
            sleeve_not_found_error = "Sleeve could not be found! Did you remove its mod?"
        },
        v_text = {
            -- for challenges
            ch_m_sleeve = {
                "Start with {C:attention}#1#{}"
            }
        }
    }
}
