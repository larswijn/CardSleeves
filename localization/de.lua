-- German translation by onichama and Phrog
return {
    descriptions = {
        Mod = {
            CardSleeves = {
                name = "Card Sleeves",
                text = {
                    "{s:1.3}Fügt {s:1.3,C:attention}15{} {s:1.3,E:1,C:dark_edition}Hüllen{} {s:1.3}als Modifikation zu Decks hinzu.",
                    " ",
                    "Inklusive API für andere Mods",
                    "um eigene Kartenhüllen hinzuzufügen.",
                    " ",
                    "Programmierung und Implementation von {C:blue}Larswijn{}.",
                    "Originale Idee und Illustration von {C:red}Sable{}.",
                    " ",
                    "{s:1.1}Siehe https://github.com/larswijn/CardSleeves (Englisch) für mehr Informationen."
                }
            }
        },
        Sleeve = {
            sleeve_casl_none = {
                name = "Keine Hülle",
                text = { "Keine Modifikationen" }
            },

            sleeve_locked = {
                name = "Gesperrt",
                text = {
                    "Gewinne einen Durchlauf mit",
                    "{C:attention}#1#{} auf",
                    "mindestens {V:1}#2#{}-Schwierigkeit"
                }
            },

            sleeve_casl_red = {
                name = "Rote Hülle",
                text = G.localization.descriptions.Back["b_red"].text
            },
            sleeve_casl_red_alt = {
                name = "Rote Hülle",
                text = {
                    "{C:red}+#1#{} Abwurf pro Runde",
                    "",
                    "{C:blue}#2#{} Hand pro Runde"
                },
            },

            sleeve_casl_blue = {
                name = "Blaue Hülle",
                text = G.localization.descriptions.Back["b_blue"].text
            },
            sleeve_casl_blue_alt = {
                name = "Blaue Hülle",
                text = {
                    "{C:blue}+#1#{} Hand pro Runde",
                    "",
                    "{C:red}#2#{} Abwurf pro Runde"
                },
            },

            sleeve_casl_yellow = {
                name = "Gelbe Hülle",
                text = G.localization.descriptions.Back["b_yellow"].text
            },
            sleeve_casl_yellow_alt = {
                name = "Gelbe Hülle",
                text = {
                    "Beginne Durchlauf mit",
                    "{C:money,T:v_seed_money}#1#{}-Gutschein"
                },
            },

            sleeve_casl_green = {
                name = "Grüne Hülle",
                text = G.localization.descriptions.Back["b_green"].text
            },
            sleeve_casl_green_alt = {
                name = "Grüne Hülle",
                text = {
                    "Kann bis zu",
                    "{C:red}-$#1#{} Schulden aufnehmen",
                    "für jede Hand und Abwurf",
                    "{C:inactive}(Aktuell {C:red}-$#2#{C:inactive})"
                }
            },

            sleeve_casl_black = {
                name = "Schwarze Hülle",
                text = G.localization.descriptions.Back["b_black"].text
            },
            sleeve_casl_black_alt = {
                name = "Schwarze Hülle",
                text = {
                    "{C:attention}+#1#{} Joker Slot",
                    "",
                    "{C:red}-#2#{} Abwurf",
                    "pro Runde"
                }
            },

            sleeve_casl_magic = {
                name = "Zauberhülle",
                text = G.localization.descriptions.Back["b_magic"].text
            },
            sleeve_casl_magic_alt = {
                name = "Zauberhülle",
                text = {
                    "Beginne Durchlauf mit",
                    "{C:tarot,T:v_omen_globe}#1#{}-Gutschein",
                }
            },

            sleeve_casl_nebula = {
                name = "Nebula-Hülle",
                text = G.localization.descriptions.Back["b_nebula"].text
            },
            sleeve_casl_nebula_alt = {
                name = "Nebula-Hülle",
                text = {
                    "Beginne den Durchlauf mit",
                    "{C:planet,T:v_observatory}#1#{}-Gutschein",
                    }
            },

            sleeve_casl_ghost = {
                name = "Geister-Hülle",
                text = G.localization.descriptions.Back["b_ghost"].text
            },
            sleeve_casl_ghost_alt = {
                name = "Geister-Hülle",
                text = {
                    "{C:spectral}Geister{}-Karten erscheinen",
                    "doppelt so häufig im Shop,",
                    "{C:spectral}Geister{}-Pakete haben {C:attention}#1#{}",
                    "extra Auswahlmöglichkeit",
                }
            },

            sleeve_casl_abandoned = {
                name = "Verlassene Hülle",
                text = G.localization.descriptions.Back["b_abandoned"].text
            },
            sleeve_casl_abandoned_alt = {
                name = "Verlassene Hülle",
                text = {
                    "Es tauchen während des Durchlaufs",
                    "keine {C:attention}Bildkarten{} mehr auf",
                }
            },

            sleeve_casl_checkered = {
                name = "Karierte Hülle",
                text = G.localization.descriptions.Back["b_checkered"].text
            },
            sleeve_casl_checkered_alt = {
                name = "Karierte Hülle",
                text = {
                    "Alle {C:clubs}Kreuz{}-Karten werden",
                    "zu {C:spades}Pik{} umgewandelt und",
                    "alle {C:diamonds}Karo{}-Karten werden",
                    "zu {C:hearts}Herz{} umgewandelt",
                }
            },

            sleeve_casl_zodiac = {
                name = "Sternzeichen-Hülle",
                text = G.localization.descriptions.Back["b_zodiac"].text
            },
            sleeve_casl_zodiac_alt = {
                name = "Sternzeichen-Hülle",
                text = {
                    "{C:tarot}Tarot{}- und {C:planet}Planeten-{}Pakete haben je ",
                    "{C:attention}#1#{} extra Auswahlmöglichkeit",
                }
            },

            sleeve_casl_painted = {
                name = "Farbige Hülle",
                text = G.localization.descriptions.Back["b_painted"].text
            },
            sleeve_casl_painted_alt = {
                name = "Farbige Hülle",
                text = {
                    "{C:attention}+#1#{} Karten Auswahllimit,",
                    "{C:red}#2#{} Joker Slot",
                }
            },

            sleeve_casl_anaglyph = {
                -- TODO check with original localization
                name = "Anaglyphen-Hülle",
                text = G.localization.descriptions.Back["b_anaglyph"].text
            },
            sleeve_casl_anaglyph_alt = {
                name = "Anaglyphen-Hülle",
                text = {
                    "Nach Besiegen eines",
                    "{C:attention}Small{} oder {C:attention}Big Blinds{}, erhalte",
                    "ein {C:attention,T:tag_double}#1#"
                }
            },

            sleeve_casl_plasma = {
                name = "Plasma-Hülle",
                text = G.localization.descriptions.Back["b_plasma"].text
            },
            sleeve_casl_plasma_alt = {
                name = "Plasma-Hülle",
                text = {
                    "Gleiche {C:money}Preis{} aller Items",
                    "im {C:attention}Shop{} aus",
                }
            },

            sleeve_casl_erratic = {
                name = "Launische Hülle",
                text = G.localization.descriptions.Back["b_erratic"].text
            },
            sleeve_casl_erratic_alt = {
                name = "Launische Hülle",
                text = {
                    "Anzahl der {C:blue}Hände{}, {C:red}Abwürfe{},",
                    "{C:money}Dollars{}, und {C:attention}Joker Slots{}",
                    "sind zufällig zwischen {C:attention}#1#{} und {C:attention}#2#{}",
                }
            }
        }
    },
    misc = {
        dictionary = {
            k_sleeve = "Hülle",
            k_sleeves = "Hüllen",
            gald_sleeves = "Wähle Hülle",
            gald_random_sleeve = "Zufällige Hülle",
            sleeve_unique_effect_desc = "Manche Hüllen haben einen Spezialeffekt in Kombination mit bestimmten Decks",
            adjust_deck_alignment = "Deck stapeln",
            adjust_deck_alignment_desc = {
                "Stapel die Karten im Deck",
                "viel enger in einem Durchlauf, um",
                "Verzerren der Hülle zu verhindern (nur optisch)"
            },
            adjust_deck_alignment_options = {
                "Immer stapeln",
                "Wenn Hülle genutzt wird",
                "Nie stapeln"
            },
            allow_any_sleeve_selection = "Schalte alle Hüllen frei",
            allow_any_sleeve_selection_desc = {
                "Alle Hüllen können für einen neuen Durchlauf",
                "ausgewählt werden, als wären sie freigeschalten"
            },
            sleeve_info_location = "Anzeige für Hüllen-Info",
            sleeve_info_location_desc = {
                "In welchem Menü werden Name und Beschreibung",
                "der aktuell genutzen Hülle angezeigt",
                "(nur optisch)"
            },
            sleeve_info_location_options = {
                "Nur in Deck-Ansicht",
                "Nur in Durchlauf-Info",
                "Zeige in Beidem",
                "Vestecke Hüllen-Info"
            },
            sleeve_not_found_error = "Hülle konnte nicht gefunden werden! Hast du den entsprechenden Mod entfernt?"
        },
        v_text = {
            -- for challenges
            ch_m_sleeve = {
                "Beginne mit {C:attention}#1#{}"
            }
        }
    }
}
