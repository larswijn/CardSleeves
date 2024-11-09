-- Chinese translation by Mr. Clover
return {
    descriptions = {
        Sleeve = {
            sleeve_casl_none = {
                name = "无卡套",
                text = { "无卡套增益效果" }
            },

            sleeve_locked = {
                name = "锁定",
                text = {
                    "在{V:1}#2#{}或以上的难度",
                    "以{C:attention}#1#{}牌組",
                    "贏得一局"
                }
            },

            sleeve_casl_red = {
                name = "紅卡套",
                text = G.localization.descriptions.Back["b_red"].text
            },

            sleeve_casl_blue = {
                name = "藍卡套",
                text = G.localization.descriptions.Back["b_blue"].text
            },

            sleeve_casl_yellow = {
                name = "黃卡套",
                text = G.localization.descriptions.Back["b_yellow"].text
            },

            sleeve_casl_green = {
                name = "绿卡套",
                text = {
                    "每回合结束时：",
                    "每剩一次{C:blue}出牌次数，獲得+{C:money}$#1#{s:0.85}",
                    "每剩一次{C:red}弃牌次数，獲得+{C:money}$#2#{s:0.85}",
                    "不赚取任何{C:attention}利息"
                    }
            },

            sleeve_casl_black = {
                name = "黑色卡套",
                text = G.localization.descriptions.Back["b_black"].text
            },
            sleeve_casl_black_alt = {
                name = "黑色卡套",
                text = {
                    "小丑牌槽位{C:attention}+#1#{}",
                    "每回合",
                    "弃牌次数{C:red}-#2#{}"
                }
            },

            sleeve_casl_magic = {
                name = "魔法卡套",
                text = G.localization.descriptions.Back["b_magic"].text
            },
            sleeve_casl_magic_alt = {
                name = "魔法卡套",
                text = {
                    "开局时拥有",
                    "{C:tarot,T:v_omen_globe}#1#{}优惠券",
                }
            },

            sleeve_casl_nebula = {
                name = "星云卡套",
                text = G.localization.descriptions.Back["b_nebula"].text
            },
            sleeve_casl_nebula_alt = {
                name = "星云卡套",
                text = {
                    "开局时拥有",
                    "{C:planet,T:v_observatory}#1#{}优惠券",
                    }
            },

            sleeve_casl_ghost = {
                name = "幽灵卡套",
                text = G.localization.descriptions.Back["b_ghost"].text
            },
            sleeve_casl_ghost_alt = {
                name = "幽灵卡套",
                text = {
                    "加倍{C:spectral}幻灵牌{}在商店中",
                    "出现的频率",
                    "{C:spectral}幻灵包{}有额外{",
                    "C:attention}#1#{}张卡",
                }
            },

            sleeve_casl_abandoned = {
                name = "废弃卡套",
                text = G.localization.descriptions.Back["b_abandoned"].text
            },
            sleeve_casl_abandoned_alt = {
                name = "废弃卡套",
                text = {
                    "{C:attention}人头牌{}不会",
                    "出现在此局"
                }
            },

            sleeve_casl_checkered = {
                name = "方格卡套",
                text = G.localization.descriptions.Back["b_checkered"].text
            },
            sleeve_casl_checkered_alt = {
                name = "方格卡套",
                text = {
                    "所有{C:clubs}梅花{}卡牌",
                    "会转成{C:spades}黑桃{}",
                    "所有{C:diamonds}方块{}卡牌",
                    "会转成{C:hearts}红心{}",
                }
            },

            sleeve_casl_zodiac = {
                name = "黄道卡套",
                text = G.localization.descriptions.Back["b_zodiac"].text
            },
            sleeve_casl_zodiac_alt = {
                name = "黄道卡套",
                text = {
                    "{C:tarot}秘术{}及{C:planet}天体{}包",
                    "有额外{C:attention}#1#{}个选项",
                }
            },

            sleeve_casl_painted = {
                name = "彩绘卡套",
                text = G.localization.descriptions.Back["b_painted"].text
            },

            sleeve_casl_anaglyph = {
                name = "浮雕卡套",
                text = G.localization.descriptions.Back["b_anaglyph"].text
            },
            sleeve_casl_anaglyph_alt = {
                name = "浮雕卡套",
                text = {
                    "击败{C:attention}小盲注{}",
                    "或{C:attention}大盲注{}后，",
                    "获得一个{C:attention,T:tag_double}#1#"
                }
            },

            sleeve_casl_plasma = {
                name = "等离子卡套",
                text = G.localization.descriptions.Back["b_plasma"].text
            },
            sleeve_casl_plasma_alt = {
                name = "等离子卡套",
                text = {
                    "平衡在{C:attention}商店{}中",
                    "所有物品的{C:money}价格{}",
                }
            },

            sleeve_casl_erratic = {
                name = "古怪卡套",
                text = G.localization.descriptions.Back["b_erratic"].text
            },
            sleeve_casl_erratic_alt = {
                name = "古怪卡套",
                text = {
                    "{C:blue}出牌{}、{C:red}弃牌{}、{C:money}金钱{}",
                    "及{C:attention}小丑牌槽位{}的初始值",
                    "都随机介于{C:attention}#1#{}及{C:attention}#2#{}开局",
                }
            }
        }
    },
    misc = {
        dictionary = {
            k_sleeve = "卡套",
            gald_sleeves = "选择卡套",
            gald_random_sleeve = "随机卡套",
            sleeve_unique_effect_desc = "一些卡套会对对应的牌组带有独特的效果",
            adjust_deck_alignment = "叠起卡牌",
            adjust_deck_alignment_desc = {
                "让牌组及卡套在游戏时更贴近",
                "（无任何游戏效果）"
            },
            allow_any_sleeve_selection = "解锁所有卡套",
            allow_any_sleeve_selection_desc = {
                "允许选用任意卡套，",
                "即使它们尚未被解锁"
            },
            sleeve_info_location = "卡套资料显示",
            sleeve_info_location_desc = {
                "选择在哪个画面中，显示",
                "所使用的卡套的名称及描述",
                "（无任何游戏效果）"
            },
            sleeve_info_location_options = {
                "只在查看牌组",
                "只在比赛信息",
                "在双方显示",
                "隐藏卡套资料"
            },
            sleeve_not_found_error = "找不到卡套！请确认提供此卡套的模组是否已安装！"
        },
        v_text = {
            -- for challenges
            ch_m_sleeve = {
                "开局时拥有{C:attention}#1#{}"
            }
        }
    }
}
