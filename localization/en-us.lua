return {
    descriptions = {
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

            sleeve_casl_blue = {
                name = "Blue Sleeve",
                text = G.localization.descriptions.Back["b_blue"].text
            },

            sleeve_casl_yellow = {
                name = "Yellow Sleeve",
                text = G.localization.descriptions.Back["b_yellow"].text
            },

            sleeve_casl_green = {
                name = "Green Sleeve",
                text = {
                    "At end of each Round:",
                    "+{C:money}$#1#{s:0.85} per remaining {C:blue}Hand",
                    "+{C:money}$#2#{s:0.85} per remaining {C:red}Discard",
                    "Earn no {C:attention}Interest"
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
            gald_sleeves = "Select Sleeve",
            gald_random_sleeve = "Random Sleeve",
            adjust_deck_alignment = "Stack deck pile",
            sleeve_not_found_error = "Sleeve could not be found! Did you remove its mod?"
        }
    }
}