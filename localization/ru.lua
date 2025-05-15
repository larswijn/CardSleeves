-- Russian translation by EnderDrag0n and Astryder
return {
    descriptions = {
        Mod = {
            CardSleeves = {
                name = "Card Sleeves",
                text = {
                    "{s:1.3}Добавляет {s:1.3,C:attention}15{} {s:1.3,E:1,C:dark_edition}Рукавов{} {s:1.3}как модификаторы для колод.",
                    " ",
                    "Имеет свой API, чтобы другие моды",
                    "могли добавлять свои Рукава.",
                    " ",
                    "Программирование и реализация {C:blue}Larswijn{}.",
                    "Идея и рисовка {C:red}Sable{}.",
                    " ",
                    "{s:1.1}Смотрите https://github.com/larswijn/CardSleeves для большей информации."
                }
            }
        },
        Sleeve = {
            sleeve_casl_none = {
                name = "Без Рукава",
                text = { "Никаких модификаторов" }
            },

            sleeve_locked = {
                name = "Закрыто",
                text = {
                    "Выиграйте забег с",
                    "{C:attention}#1#{}",
                    "на {V:1}#2#{}"
                }
            },

            sleeve_casl_red = {
                name = "Красный Рукав",
                text = G.localization.descriptions.Back["b_red"].text
            },
            sleeve_casl_red_alt = {
                name = "Красный Рукав",
                text = {
                    "{C:red}+#1#{} сброс",
                    "",
                    "{C:blue}#2#{} рука"
                },
            },

            sleeve_casl_blue = {
                name = "Синий Рукав",
                text = G.localization.descriptions.Back["b_blue"].text
            },
            sleeve_casl_blue_alt = {
                name = "Синий Рукав",
                text = {
                    "{C:blue}+#1#{} рука",
                    "",
                    "{C:red}#2#{} сброс"
                },
            },

            sleeve_casl_yellow = {
                name = "Жёлтый Рукав",
                text = G.localization.descriptions.Back["b_yellow"].text
            },
            sleeve_casl_yellow_alt = {
                name = "Жёлтый Рукав",
                text = {
                    "С начала партии имеется",
                    "{C:money,T:v_seed_money}#1#{}"
                },
            },

            sleeve_casl_green = {
                name = "Зелёный Рукав",
                text = G.localization.descriptions.Back["b_green"].text
            },
            sleeve_casl_green_alt = {
                name = "Зелёный Рукав",
                text = {
                    "Можно взять в долг на",
                    "{C:red}-$#1#{} за каждую",
                    "руку и сброс",
                    "{C:inactive}(Сейчас {C:red}-$#2#{C:inactive})"
                }
            },

            sleeve_casl_black = {
                name = "Чёрный Рукав",
                text = G.localization.descriptions.Back["b_black"].text
            },
            sleeve_casl_black_alt = {
                name = "Чёрный Рукав",
                text = {
                    "{C:attention}+#1#{} слот джокера",
                    "",
                    "{C:red}-#2#{} сброс",
                }
            },

            sleeve_casl_magic = {
                name = "Волшебный Рукав",
                text = G.localization.descriptions.Back["b_magic"].text
            },
            sleeve_casl_magic_alt = {
                name = "Волшебный Рукав",
                text = {
                    "С начала партии имеется",
                    "{C:tarot,T:v_omen_globe}#1#{}",
                }
            },

            sleeve_casl_nebula = {
                name = "Туманный Рукав",
                text = G.localization.descriptions.Back["b_nebula"].text
            },
            sleeve_casl_nebula_alt = {
                name = "Туманный Рукав",
                text = {
                    "С начала партии имеется",
                    "{C:planet,T:v_observatory}#1#{}",
                    }
            },

            sleeve_casl_ghost = {
                name = "Призрачный Рукав",
                text = G.localization.descriptions.Back["b_ghost"].text
            },
            sleeve_casl_ghost_alt = {
                name = "Призрачный Рукав",
                text = {
                    "Шанс появления",
                    " {C:spectral}Спектральных{} карт удвоен,",
                    "{C:spectral}Спектральные наборы{} имеют",
                    "на {C:attention}#1#{} карты больше",
                }
            },

            sleeve_casl_abandoned = {
                name = "Заброшенный Рукав",
                text = G.localization.descriptions.Back["b_abandoned"].text
            },
            sleeve_casl_abandoned_alt = {
                name = "Заброшенный Рукав",
                text = {
                    "{C:attention}Лицевые карты{}",
                    "больше не появятся в партии"
                }
            },

            sleeve_casl_checkered = {
                name = "Клетчатый Рукав",
                text = G.localization.descriptions.Back["b_checkered"].text
            },
            sleeve_casl_checkered_alt = {
                name = "Клетчатый Рукав",
                text = {
                    "Все {C:clubs}Трефы{}",
                    "станут {C:spades}Пиками{} и",
                    "все {C:diamonds}Бубны{} станут",
                    "{C:hearts}Червями{}",
                }
            },

            sleeve_casl_zodiac = {
                name = "Зодиакальный Рукав",
                text = G.localization.descriptions.Back["b_zodiac"].text
            },
            sleeve_casl_zodiac_alt = {
                name = "Зодиакальный Рукав",
                text = {
                    "{C:tarot}Аркана{} и {C:planet}Небесные{} наборы имеют",
                    "на {C:attention}#1#{} карты больше",
                }
            },

            sleeve_casl_painted = {
                name = "Рисованный Рукав",
                text = G.localization.descriptions.Back["b_painted"].text
            },
            sleeve_casl_painted_alt = {
                name = "Рисованный Рукав",
                text = {
                    "{C:attention}+#1#{} лимит выбора карт,",
                    "{C:red}#2#{} слот джокера",
                }
            },

            sleeve_casl_anaglyph = {
                name = "Анаглифический Рукав",
                text = G.localization.descriptions.Back["b_anaglyph"].text
            },
            sleeve_casl_anaglyph_alt = {
                name = "Анаглифический Рукав",
                text = {
                    "{C:attention,T:tag_double}#1#{} после победы над",
                    "{C:attention}Малым{} или {C:attention}Большим Блайндом{},",
                }
            },

            sleeve_casl_plasma = {
                name = "Плазменный Рукав",
                text = G.localization.descriptions.Back["b_plasma"].text
            },
            sleeve_casl_plasma_alt = {
                name = "Плазменный Рукав",
                text = {
                    "Усреднение {C:money}цен{} всех предметов",
                    "в {C:attention}магазине{}",
                }
            },

            sleeve_casl_erratic = {
                name = "Неустойчивый Рукав",
                text = G.localization.descriptions.Back["b_erratic"].text
            },
            sleeve_casl_erratic_alt = {
                name = "Неустойчивый Рукав",
                text = {
                    "Изначальное количество {C:blue}рук{}, {C:red}сбросов{},",
                    "{C:money}${}, и {C:attention}слотов джокера{}",
                    "случайно между {C:attention}#1#{} и {C:attention}#2#{}",
                }
            }
        }
    },
    misc = {
        dictionary = {
            k_sleeve = "Рукав",
            k_sleeves = "Рукава",
            gald_sleeves = "Выберите Рукав",
            gald_random_sleeve = "Случайный Рукав",
            sleeve_unique_effect_desc = "Некоторые рукава имеют уникальные эффекты, если использованы с соответствующей им колодой",
            adjust_deck_alignment = "Укладывать карты колоды",
            adjust_deck_alignment_desc = {
                "Укладывать карты в колоде",
                "более тесно во время забега, чтобы",
                "убрать растягивание рукава (влияет только на внешний вид)"
            },
            adjust_deck_alignment_options = {
                "Всегда",
                "Только при использовании рукава",
                "Никогда"
            },
            allow_any_sleeve_selection = "Открыть все рукава",
            allow_any_sleeve_selection_desc = {
                "Позволяет выбрать любой рукав,",
                "даже если он не был открыт"
            },
            sleeve_info_location = "Местоположение информации о Рукаве",
            sleeve_info_location_desc = {
                "В каком меню название и описание",
                "текущего рукава будет показано",
                "(влияет только на внешний вид)"
            },
            sleeve_info_location_options = {
                "Только в просмотре колоды",
                "Только в деталях партии",
                "Показывать в обоих",
                "Нигде не показывать"
            },
            sleeve_not_found_error = "Рукав не найден! Вы удалили мод с ним?"
        },
        v_text = {
            -- for challenges
            ch_m_sleeve = {
                "Начать с {C:attention}#1#{}"
            }
        }
    }
}
