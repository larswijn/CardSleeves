-- Chinese translation by Mr. Clover and Dimserene
return {
    descriptions = {
        Mod = {
            CardSleeves = {
                name = "牌套",
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
                name = "无牌套",
                text = { "无牌套模式" }
            },

            sleeve_locked = {
                name = "锁定",
                text = {
                    "在{V:1}#2#{}或以上",
                    "难度以{C:attention}#1#{}牌組",
                    "贏得一局"
                }
            },

            sleeve_casl_red = {
                name = "红色牌套",
                text = G.localization.descriptions.Back["b_red"].text
            },
            sleeve_casl_red_alt = {
                name = "红色牌套",
                text = {
                    "每回合",
                    "{C:blue}#2#{}次出牌",
                    "{C:red}+#1#{}次弃牌",
                },
            },

            sleeve_casl_blue = {
                name = "蓝色牌套",
                text = G.localization.descriptions.Back["b_blue"].text
            },
            sleeve_casl_blue_alt = {
                name = "蓝色牌套",
                text = {
                    "每回合",
                    "{C:blue}+#1#{}次出牌",
                    "{C:red}#2#{}次弃牌"
                },
            },

            sleeve_casl_yellow = {
                name = "黃色牌套",
                text = G.localization.descriptions.Back["b_yellow"].text
            },
            sleeve_casl_yellow_alt = {
                name = "黃色牌套",
                text = {
                    "开局时拥有",
                    "{C:money,T:v_seed_money}#1#{}优惠券",
                },
            },

            sleeve_casl_green = {
                name = "绿色牌套",
                text = G.localization.descriptions.Back["b_green"].text
            },
            sleeve_casl_green_alt = {
                name = "绿色牌套",
                text = {
                    "每有一次出牌、弃牌次数",
                    "可让你多负债{C:red}-$#1#{}",
                    "{C:inactive}（可以负债最多{C:red}-$#2#{C:inactive}）"
                }
            },

            sleeve_casl_black = {
                name = "黑色牌套",
                text = G.localization.descriptions.Back["b_black"].text
            },
            sleeve_casl_black_alt = {
                name = "黑色牌套",
                text = {
                    "小丑牌槽位{C:attention}+#1#{}",
                    "每回合",
                    "弃牌次数{C:red}-#2#{}"
                }
            },

            sleeve_casl_magic = {
                name = "魔法牌套",
                text = G.localization.descriptions.Back["b_magic"].text
            },
            sleeve_casl_magic_alt = {
                name = "魔法牌套",
                text = {
                    "开局时拥有",
                    "{C:tarot,T:v_omen_globe}#1#{}优惠券",
                }
            },

            sleeve_casl_nebula = {
                name = "星云牌套",
                text = G.localization.descriptions.Back["b_nebula"].text
            },
            sleeve_casl_nebula_alt = {
                name = "星云牌套",
                text = {
                    "开局时拥有",
                    "{C:planet,T:v_observatory}#1#{}优惠券",
                    }
            },

            sleeve_casl_ghost = {
                name = "幽灵牌套",
                text = G.localization.descriptions.Back["b_ghost"].text
            },
            sleeve_casl_ghost_alt = {
                name = "幽灵牌套",
                text = {
                    "商店内{C:spectral}幻灵牌{}",
                    "出现频率{C:attention}X2",
                    "所有{C:spectral}幻灵包{}将额外",
                    "生成{C:attention}#1#{}张待选牌",
                }
            },

            sleeve_casl_abandoned = {
                name = "废弃牌套",
                text = G.localization.descriptions.Back["b_abandoned"].text
            },
            sleeve_casl_abandoned_alt = {
                name = "废弃牌套",
                text = {
                    "本赛局内{C:attention}人头牌{}",
                    "将永远不会出现"
                }
            },

            sleeve_casl_checkered = {
                name = "方格牌套",
                text = G.localization.descriptions.Back["b_checkered"].text
            },
            sleeve_casl_checkered_alt = {
                name = "方格牌套",
                text = {
                    "所有出现的{C:clubs}梅花{}将被替换为{C:spades}黑桃{}",
                    "所有出现的{C:diamonds}方片{}将被替换为{C:hearts}红桃{}",
                }
            },

            sleeve_casl_zodiac = {
                name = "黄道牌套",
                text = G.localization.descriptions.Back["b_zodiac"].text
            },
            sleeve_casl_zodiac_alt = {
                name = "黄道牌套",
                text = {
                    "所有{C:tarot}秘术包{}和{C:planet}天体包{}",
                    "将额外生成{C:attention}#1#{}张待选牌",
                }
            },

            sleeve_casl_painted = {
                name = "彩绘牌套",
                text = G.localization.descriptions.Back["b_painted"].text
            },
            sleeve_casl_painted_alt = {
                name = "彩绘牌套",
                text = {
                    "可选中的卡牌上限{C:attention}+#1#{}",
                    "小丑牌槽位{C:red}#2#{}",
                }
            },

            sleeve_casl_anaglyph = {
                name = "浮雕牌套",
                text = G.localization.descriptions.Back["b_anaglyph"].text
            },
            sleeve_casl_anaglyph_alt = {
                name = "浮雕牌套",
                text = {
                    "每次击败{C:attention}小盲注{}",
                    "或{C:attention}大盲注{}后",
                    "获得一个{C:attention,T:tag_double}#1#"
                }
            },

            sleeve_casl_plasma = {
                name = "等离子牌套",
                text = G.localization.descriptions.Back["b_plasma"].text
            },
            sleeve_casl_plasma_alt = {
                name = "等离子牌套",
                text = {
                    "平衡{C:attention}商店内{}",
                    "所有物品的{C:money}售价{}",
                }
            },

            sleeve_casl_erratic = {
                name = "古怪牌套",
                text = G.localization.descriptions.Back["b_erratic"].text
            },
            sleeve_casl_erratic_alt = {
                name = "古怪牌套",
                text = {
                    "开局的{C:blue}出牌次数{}，{C:red}弃牌次数{}",
                    "以及{C:money}资金数{}和{C:attention}小丑牌槽位数{}",
                    "都将从{C:attention}#1#{}~{C:attention}#2#{}中随机取值",
                }
            }
        }
    },
    misc = {
        dictionary = {
            k_sleeve = "牌套",
            k_sleeves = "牌套",
            gald_sleeves = "选择牌套",
            gald_random_sleeve = "随机牌套",
            sleeve_unique_effect_desc = "牌套与对应牌组共同使用时产生独特效果",
            adjust_deck_alignment = "堆叠卡牌",
            adjust_deck_alignment_desc = {
                "让牌组及牌套在游戏中更贴近",
                "防止卡牌超出牌套",
                "（无任何游戏性效果）"
            },
            adjust_deck_alignment_options = {
                "总是堆叠",
                "使用牌套时堆叠",
                "永不堆叠"
            },
            allow_any_sleeve_selection = "解锁所有牌套",
            allow_any_sleeve_selection_desc = {
                "允许选用任意牌套",
                "即使它们尚未被解锁"
            },
            sleeve_info_location = "牌套信息显示",
            sleeve_info_location_desc = {
                "选择在哪个菜单栏中显示",
                "所使用的牌套名称及描述",
                "（无任何游戏性效果）"
            },
            sleeve_info_location_options = {
                "显示在牌组信息",
                "显示在赛局信息",
                "同时显示",
                "隐藏牌套信息"
            },
            sleeve_not_found_error = "找不到牌套！请确认此模组是否正确安装！"
        },
        v_text = {
            -- for challenges
            ch_m_sleeve = {
                "开局时拥有{C:attention}#1#{}"
            }
        }
    }
}
