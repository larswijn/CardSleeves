-- Spanish translation by Batolol and Yamper
return {
    descriptions = {
        Mod = {
            CardSleeves = {
                name = "Card Sleeves",
                text = {
                    "{s:1.3}Añade {s:1.3,C:attention}15{} {s:1.3,E:1,C:dark_edition}Fundas{} {s:1.3}como modificadores de barajas.",
                    " ",
                    "Incluye una API para otros mods",
                    "para añadir sus propias fundas.",
                    " ",
                    "Programación e implementación por {C:blue}Larswijn{}.",
                    "Idea y arte original por {C:red}Sable{}.",
                    " ",
                    "{s:1.1}Vea https://github.com/larswijn/CardSleeves para más información."
                }
            }
        },
        Sleeve = {
            sleeve_casl_none = {
                name = "Sin funda",
                text = { "Sin modificadores de funda" }
            },

            sleeve_locked = {
                name = "Bloqueada",
                text = {
                    "Gana una partida",
                    "con {C:attention}#1#{}",
                    "en {V:1}#2#{} como mínimo"
                }
            },

            sleeve_casl_red = {
                name = "Funda roja",
                text = G.localization.descriptions.Back["b_red"].text
            },
            sleeve_casl_red_alt = {
                name = "Funda roja",
                text = {
                    "{C:red}+#1#{} descarte en cada ronda",
                    "",
                    "{C:blue}#2#{} mano en cada ronda"
                },
            },

            sleeve_casl_blue = {
                name = "Funda azul",
                text = G.localization.descriptions.Back["b_blue"].text
            },
            sleeve_casl_blue_alt = {
                name = "Funda azul",
                text = {
                    "{C:blue}+#1#{} mano en cada ronda",
                    "",
                    "{C:red}#2#{} descarte en cada ronda"
                },
            },

            sleeve_casl_yellow = {
                name = "Funda amarilla",
                text = G.localization.descriptions.Back["b_yellow"].text
            },
            sleeve_casl_yellow_alt = {
                name = "Funda amarilla",
                text = {
                    "Comienza la partida con el vale",
                    "{C:money,T:v_seed_money}#1#{}"
                },
            },

            sleeve_casl_green = {
                name = "Funda verde",
                text = G.localization.descriptions.Back["b_green"].text
            },
            sleeve_casl_green_alt = {
                name = "Funda verde",
                text = {
                    "Adquiere hasta",
                    "{C:red}-$#1#{} de deuda por",
                    "cada mano y descarte ",
                    "{C:inactive}(Actual {C:red}-$#2#{C:inactive})"
                }
            },

            sleeve_casl_black = {
                name = "Funda negra",
                text = G.localization.descriptions.Back["b_black"].text
            },
            sleeve_casl_black_alt = {
                name = "Funda negra",
                text = {
                    "{C:attention}+#1#{} ranura de comodín",
                    "",
                    "{C:red}-#2#{} descartes",
                    "cada ronda"
                }
            },

            sleeve_casl_magic = {
                name = "Funda mágica",
                text = G.localization.descriptions.Back["b_magic"].text
            },
            sleeve_casl_magic_alt = {
                name = "Funda mágica",
                text = {
                    "Comienza la partida con",
                    "el vale {C:tarot,T:v_omen_globe}#1#{}",
                }
            },

            sleeve_casl_nebula = {
                name = "Funda nébula",
                text = G.localization.descriptions.Back["b_nebula"].text
            },
            sleeve_casl_nebula_alt = {
                name = "Funda nébula",
                text = {
                    "Comienza la partida con el",
                    "vale {C:planet,T:v_observatory}#1#{}",
                }
            },

            sleeve_casl_ghost = {
                name = "Funda fastasma",
                text = G.localization.descriptions.Back["b_ghost"].text
            },
            sleeve_casl_ghost_alt = {
                name = "Funda fastasma",
                text = {
                    "La aparición de cartas {C:spectral}espectrales{}",
                    "en la tienda se duplica,",
                    "{C:spectral}paquetes espectrales{} tienen {C:attention}#1#{}",
                    "opciones extra para elegir",
                }
            },

            sleeve_casl_abandoned = {
                name = "Funda abandonada",
                text = G.localization.descriptions.Back["b_abandoned"].text
            },
            sleeve_casl_abandoned_alt = {
                name = "Funda abandonada",
                text = {
                    "Las cartas de {C:attention}figuras{} no",
                    "aparecerán durante la partida"
                }
            },

            sleeve_casl_checkered = {
                name = "Funda cuadriculada",
                text = G.localization.descriptions.Back["b_checkered"].text
            },
            sleeve_casl_checkered_alt = {
                name = "Funda cuadriculada",
                text = {
                    "Todas las cartas de {C:clubs}trébol{} serán",
                    "convertidas en {C:spades}pica{} y",
                    "todas las cartas de {C:diamonds}diamante{} serán",
                    "convertidas en {C:hearts}corazón{}",
                }
            },

            sleeve_casl_zodiac = {
                name = "Funda del zodiaco",
                text = G.localization.descriptions.Back["b_zodiac"].text
            },
            sleeve_casl_zodiac_alt = {
                name = "Funda del zodiaco",
                text = {
                    "Los paquetes {C:tarot}arcanos{} y",
                    "{C:planet}celestiales{} tienen",
                    "{C:attention}#1#{} opciones extra para elegir",
                }
            },

            sleeve_casl_painted = {
                name = "Funda pintada",
                text = G.localization.descriptions.Back["b_painted"].text
            },
            sleeve_casl_painted_alt = {
                name = "Funda pintada",
                text = {
                    "{C:attention}+#1#{} límite de selección de carta,",
                    "{C:red}#2#{} ranuras de comodín",
                }
            },

            sleeve_casl_anaglyph = {
                name = "Funda anaglifo",
                text = G.localization.descriptions.Back["b_anaglyph"].text
            },
            sleeve_casl_anaglyph_alt = {
                name = "Funda anaglifo",
                text = {
                    "Despues de derrotar cada",
                    "{C:attention}Ciega pequeña{} o {C:attention}Ciega grande{} gana",
                    "1 {C:attention,T:tag_double}#1#"
                }
            },

            sleeve_casl_plasma = {
                name = "Funda plasmática",
                text = G.localization.descriptions.Back["b_plasma"].text
            },
            sleeve_casl_plasma_alt = {
                name = "Funda plasmática",
                text = {
                    "Equilibra el {C:money}precio{}",
                    "de todos los objetos",
                    "en la {C:attention}tienda{}",
                }
            },

            sleeve_casl_erratic = {
                name = "Funda errática",
                text = G.localization.descriptions.Back["b_erratic"].text
            },
            sleeve_casl_erratic_alt = {
                name = "Funda errática",
                text = {
                    "La cantidad inicial de",
                    "{C:blue}manos{}, {C:red}descartes{},",
                    "{C:money}dinero{}, y {C:attention}ranuras de comodín{}",
                    "serán aleatorizadas entre {C:attention}#1#{} y {C:attention}#2#{}",
                }
            }
        }
    },
    misc = {
        dictionary = {
            k_sleeve = "Funda",
            k_sleeves = "Fundas",
            gald_sleeves = "Elegir Funda",
            gald_random_sleeve = "Funda Aleatoria",
            run_select_casl_sleeve_choice = "Elegir Funda",
            run_select_casl_sleeve_choice_random = "Funda Aleatoria",
            sleeve_normal_effect_desc = "Algunas fundas tienen efectos únicos cuando se combinan con barajas específicas",
            sleeve_stacked_effect_desc =
            "Haz click izquierdo o derecho en una funda para ver los distintos efectos combinados",
            adjust_deck_alignment = "Apilar baraja",
            adjust_deck_alignment_desc = {
                "Apilas las cartas en el mazo",
                "más juntas durante una partida para",
                "prevenir que la funda se estire (efecto visual)"
            },
            adjust_deck_alignment_options = {
                "Siempre apilar",
                "Cuando se usa una funda",
                "No apilar"
            },
            allow_any_sleeve_selection = "Desbloquear todas las Fundas",
            allow_any_sleeve_selection_desc = {
                "Permite que cualquier funda sea seleccionada",
                "en el menú de nueva partida, como si fuese desbloqueada"
            },
            sleeve_info_location = "Ubicación de información de funda",
            sleeve_info_location_desc = {
                "En qué menú el nombre y la descripción",
                "de la funda actualmente usada debería mostrarse",
                "(solo visual)"
            },
            sleeve_info_location_options = {
                "Solo en la vista de baraja",
                "Solo en la información de partida",
                "En ambos",
                "Oculta la información de funda"
            },
            sleeve_not_found_error = "¡La funda no se pudo encontrar! ¿Removiste su mod?",
            sleeve_normal_effects = "Efecto regular",
            sleeve_stacked_effects = "Efecto combinado",
        },
        v_text = {
            -- for challenges
            ch_m_sleeve = {
                "Empieza con {C:attention}#1#{}"
            }
        }
    }
}
