-- Polish translation by avandemortell2137
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
                name = "Bez rękawa",
                text = { "Brak modyfikatorów rękawów" }
            },

            sleeve_locked = {
                name = "Zablokowany",
                text = {
                    "Wygraj podejście z",
                    "{C:attention}#1#{} na poz. trudności",
                    "{V:1}#2#{} lub wyższym"
                }
            },

            sleeve_casl_red = {
                name = "Czerwony rękaw",
                text = G.localization.descriptions.Back["b_red"].text
            },

            sleeve_casl_blue = {
                name = "Niebieski rękaw",
                text = G.localization.descriptions.Back["b_blue"].text
            },

            sleeve_casl_yellow = {
                name = "Żółty rękaw",
                text = G.localization.descriptions.Back["b_yellow"].text
            },

            sleeve_casl_green = {
                name = "Zielony rękaw",
                text = {
                    "Na końcu każdej rundy otrzymujesz:",
                    "+{C:money}$#1#{s:0.85} za każdą pozostałą {C:blue}rękę",
                    "+{C:money}$#2#{s:0.85} za każdą pozostałą {C:red}zrzutkę",
                    "Nie zarabiasz {C:attention}odsetek"
                    }
            },

            sleeve_casl_black = {
                name = "Czarny rękaw",
                text = G.localization.descriptions.Back["b_black"].text
            },
            sleeve_casl_black_alt = {
                name = "Czarny rękaw",
                text = {
                    "{C:attention}+#1#{} slot na jokera",
                    "",
                    "{C:red}-#2#{} zrzutka",
                    "w każdej rundzie"
                }
            },

            sleeve_casl_magic = {
                name = "Magiczny rękaw",
                text = G.localization.descriptions.Back["b_magic"].text
            },
            sleeve_casl_magic_alt = {
                name = "Magiczny rękaw",
                text = {
                    "Rozpoczynasz podejście z",
                    "kuponem {C:tarot,T:v_omen_globe}#1#{}",
                }
            },

            sleeve_casl_nebula = {
                name = "Mgławicowy rękaw",
                text = G.localization.descriptions.Back["b_nebula"].text
            },
            sleeve_casl_nebula_alt = {
                name = "Mgławicowy rękaw",
                text = {
                    "Rozpoczynasz podejście z",
                    "kuponem {C:planet,T:v_observatory}#1#{}",
                    }
            },

            sleeve_casl_ghost = {
                name = "Duchowy rękaw",
                text = G.localization.descriptions.Back["b_ghost"].text
            },
            sleeve_casl_ghost_alt = {
                name = "Duchowy rękaw",
                text = {
                    "{C:spectral}Karty Ducha{} pojawiają się",
                    "2 razy częściej,",
                    "{C:spectral}Paczki kart Ducha{} zawierają {C:attention}#1#{}",
                    "dodatkowe karty do wyboru",
                }
            },

            sleeve_casl_abandoned = {
                name = "Porzucony rękaw",
                text = G.localization.descriptions.Back["b_abandoned"].text
            },
            sleeve_casl_abandoned_alt = {
                name = "Porzucony rękaw",
                text = {
                    "{C:attention}Figury karciane{} nię będą już się",
                    "pojawiać w trakcie podejścia"
                }
            },

            sleeve_casl_checkered = {
                name = "Kratkowany rękaw",
                text = G.localization.descriptions.Back["b_checkered"].text
            },
            sleeve_casl_checkered_alt = {
                name = "Kratkowany rękaw",
                text = {
                    "Wszystkie {C:clubs}trefle{}",
                    "stają się {C:spades}pikami{} i",
                    "wszystkie {C:diamonds}kara{}",
                    "stają się {C:hearts}kierami{}",
                }
            },

            sleeve_casl_zodiac = {
                name = "Zodiakalny rękaw",
                text = G.localization.descriptions.Back["b_zodiac"].text
            },
            sleeve_casl_zodiac_alt = {
                name = "Zodiakalny rękaw",
                text = {
                    "{C:tarot}Paczki wiedzy tajemnej{} i {C:planet}paczki niebiańskie{} mają",
                    "{C:attention}#1#{} dodatkowe karty do wyboru",
                }
            },

            sleeve_casl_painted = {
                name = "Malowany rękaw",
                text = G.localization.descriptions.Back["b_painted"].text
            },

            sleeve_casl_anaglyph = {
                name = "Anaglificzny rękaw",
                text = G.localization.descriptions.Back["b_anaglyph"].text
            },
            sleeve_casl_anaglyph_alt = {
                name = "Anaglificzny rękaw",
                text = {
                    "Po pokonaniu zarówno",
                    "{C:attention}małej{} jak i {C:attention}dużej w ciemno{},",
                    "zdobywasz {C:attention,T:tag_double}#1#"
                }
            },

            sleeve_casl_plasma = {
                name = "Plazmowy rękaw",
                text = G.localization.descriptions.Back["b_plasma"].text
            },
            sleeve_casl_plasma_alt = {
                name = "Plazmowy rękaw",
                text = {
                    "Równoważy {C:money}ceny{} wszystkich przedmiotów",
                    "w {C:attention}sklepie{}",
                }
            },

            sleeve_casl_erratic = {
                name = "Zmienny rękaw",
                text = G.localization.descriptions.Back["b_erratic"].text
            },
            sleeve_casl_erratic_alt = {
                name = "Zmienny rękaw",
                text = {
                    "Początkowa liczba {C:blue}rąk{}, {C:red}zrzutek{},",
                    "{C:money}pieniędzy{} i {C:attention}slotów na jokery{}",
                    "jest losowo przydzielona od {C:attention}#1#{} do {C:attention}#2#{}",
                }
            }
        }
    },
    misc = {
        dictionary = {
            k_sleeve = "Rękaw",
            gald_sleeves = "Wybierz rękaw",
            gald_random_sleeve = "Losowy rękaw",
            sleeve_unique_effect_desc = "Niektóre rękawy mają unikalne efekty w połączeniu z określonymi taliami",
            adjust_deck_alignment = "Stos talii",
            adjust_deck_alignment_desc = {
                "Dokładniej układa stos talii",
                "podczas podejścia (tylko wizualnie)"
            },
            allow_any_sleeve_selection = "Odblokuj wszystkie rękawy",
            allow_any_sleeve_selection_desc = {
                "Umożliwia wybór dowolnego rękawa",
                "w menu nowego podejścia"
            },
            sleeve_info_location = "Miejsce opisu rękawa",
            sleeve_info_location_desc = {
                "W którym menu będzie pokazywana nazwa i opis",
                "obecnie wybranego rękawa",
                "(tylko wizualnie)"
            },
            sleeve_info_location_options = {
                "Tylko w podglądzie talii",
                "Tylko w informacjach o podejściu",
                "Pokaż w obu",
                "Nie pokazuj wcale"
            },
            sleeve_not_found_error = "Rękaw nie został znaleziony! Czy ten mod został usunięty?"
        },
        v_text = {
            -- for challenges
            ch_m_sleeve = {
                "Rozpocznij z {C:attention}#1#{}"
            }
        }
    }
}
