-- Traditional Chinese translation by Mr. Clover
return {
    descriptions = {
        Sleeve = {
            sleeve_casl_none = {
                name = "無牌套",
                text = { "無牌套增益效果" }
            },

            sleeve_locked = {
                name = "已鎖定",
                text = {
                    "使用{C:attention}#1#{}",
                    "在{V:1}#2#{}下贏得一局遊戲",
                }
            },

            sleeve_casl_red = {
                name = "紅色牌套",
                text = G.localization.descriptions.Back["b_red"].text
            },
            sleeve_casl_red_alt = {
                name = "紅色牌套",
                text = {
                    "棄牌次數{C:red}+#1#{}",
                    "",
                    "出牌次數{C:blue}#2#{}"
                },
            },

            sleeve_casl_blue = {
                name = "藍色牌套",
                text = G.localization.descriptions.Back["b_blue"].text
            },
            sleeve_casl_blue_alt = {
                name = "藍色牌套",
                text = {
                    "出牌次數{C:blue}+#1#{}",
                    "",
                    "棄牌次數{C:red}#2#{}"
                },
            },

            sleeve_casl_yellow = {
                name = "黃色牌套",
                text = G.localization.descriptions.Back["b_yellow"].text
            },
            sleeve_casl_yellow_alt = {
                name = "黃色牌套",
                text = {
                    "開始遊戲時獲得",
                    "{C:money,T:v_seed_money}#1#{}禮券",
                },
            },

            sleeve_casl_green = {
                name = "綠色牌套",
                text = G.localization.descriptions.Back["b_green"].text
            },
            sleeve_casl_green_alt = {
                name = "綠色牌套",
                text = {
                    "每個出牌次數及棄牌次數",
                    "可讓你負債至{C:red}-$#1#{}",
                    "{C:inactive}（目前可負債至{C:red}-$#2#{C:inactive}）"
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
                    "棄牌次數{C:red}-#2#{}"
                }
            },

            sleeve_casl_magic = {
                name = "魔法牌套",
                text = G.localization.descriptions.Back["b_magic"].text
            },
            sleeve_casl_magic_alt = {
                name = "魔法牌套",
                text = {
                    "開始遊戲時獲得",
                    "{C:tarot,T:v_omen_globe}#1#{}禮券",
                }
            },

            sleeve_casl_nebula = {
                name = "星雲牌套",
                text = G.localization.descriptions.Back["b_nebula"].text
            },
            sleeve_casl_nebula_alt = {
                name = "星雲牌套",
                text = {
                    "開始遊戲時獲得",
                    "{C:planet,T:v_observatory}#1#{}禮券",
                    }
            },

            sleeve_casl_ghost = {
                name = "幽靈牌套",
                text = G.localization.descriptions.Back["b_ghost"].text
            },
            sleeve_casl_ghost_alt = {
                name = "幽靈牌套",
                text = {
                    "加倍{C:spectral}幻靈牌{}在商店中",
                    "出現的機率",
                    "每個{C:spectral}幻靈擴充包{}",
                    "有額外{C:attention}#1#{}張牌",
                }
            },

            sleeve_casl_abandoned = {
                name = "荒廢牌套",
                text = G.localization.descriptions.Back["b_abandoned"].text
            },
            sleeve_casl_abandoned_alt = {
                name = "荒廢牌套",
                text = {
                    "{C:attention}人頭牌{}",
                    "不再出現在此局遊戲"
                }
            },

            sleeve_casl_checkered = {
                name = "格紋牌套",
                text = G.localization.descriptions.Back["b_checkered"].text
            },
            sleeve_casl_checkered_alt = {
                name = "格紋牌套",
                text = {
                    "所有{C:clubs}梅花{}卡牌",
                    "會轉換成{C:spades}黑桃{}",
                    "所有{C:diamonds}方塊{}卡牌",
                    "會轉換成{C:hearts}紅心{}",
                }
            },

            sleeve_casl_zodiac = {
                name = "星座牌套",
                text = G.localization.descriptions.Back["b_zodiac"].text
            },
            sleeve_casl_zodiac_alt = {
                name = "星座牌套",
                text = {
                    "{C:tarot}奧秘{}及{C:planet}天外{}擴充包",
                    "有額外{C:attention}#1#{}個選項",
                }
            },

            sleeve_casl_painted = {
                name = "彩繪牌套",
                text = G.localization.descriptions.Back["b_painted"].text
            },
            sleeve_casl_painted_alt = {
                name = "彩繪牌套",
                text = {
                    "可選擇的卡牌的上限{C:attention}+#1#{}",
                    "小丑牌欄位{C:red}#2#{}",
                }
            },

            sleeve_casl_anaglyph = {
                name = "立體牌套",
                text = G.localization.descriptions.Back["b_anaglyph"].text
            },
            sleeve_casl_anaglyph_alt = {
                name = "立體牌套",
                text = {
                    "擊敗{C:attention}小盲注{}",
                    "或{C:attention}大盲注{}後，",
                    "會獲得一個{C:attention,T:tag_double}#1#"
                }
            },

            sleeve_casl_plasma = {
                name = "等離子牌套",
                text = G.localization.descriptions.Back["b_plasma"].text
            },
            sleeve_casl_plasma_alt = {
                name = "等離子牌套",
                text = {
                    "平衡在{C:attention}商店{}中",
                    "所有物品的{C:money}價格{}",
                }
            },

            sleeve_casl_erratic = {
                name = "乖僻牌套",
                text = G.localization.descriptions.Back["b_erratic"].text
            },
            sleeve_casl_erratic_alt = {
                name = "乖僻牌套",
                text = {
                    "{C:blue}出牌{}、{C:red}棄牌{}、{C:money}金钱{}",
                    "及{C:attention}小丑牌欄位{}的初始值",
                    "都隨機介於{C:attention}#1#{}及{C:attention}#2#{}的形式開始遊戲",
                }
            }
        }
    },
    misc = {
        dictionary = {
            k_sleeve = "牌套",
            k_sleeves = "牌套",
            gald_sleeves = "選擇牌套",
            gald_random_sleeve = "隨機牌套",
            sleeve_unique_effect_desc = "一些牌套會與對應的牌組給予獨特的效果",
            adjust_deck_alignment = "叠起卡牌",
            adjust_deck_alignment_desc = {
                "讓牌組及牌套在遊戲時更貼近",
                "防止卡牌超出牌套",
                "（無任何遊戲效果）"
            },
            adjust_deck_alignment_options = {
                "總是叠起",
                "只使用牌套時",
                "永不叠起"
            },
            allow_any_sleeve_selection = "解鎖所有牌套",
            allow_any_sleeve_selection_desc = {
                "允許選用所有牌套",
                "包括尚未解鎖的牌套"
            },
            sleeve_info_location = "牌套資料顯示",
            sleeve_info_location_desc = {
                "選擇在哪個畫面中",
                "顯示所使用的卡套的名稱及描述",
                "（無任何遊戲效果）"
            },
            sleeve_info_location_options = {
                "只在查看牌組",
                "只在本局遊戲信息",
                "在雙方顯示",
                "隱藏牌套資料"
            },
            sleeve_not_found_error = "找不到牌套！請確認提供此牌套的模組是否已安裝！"
        },
        v_text = {
            -- for challenges
            ch_m_sleeve = {
                "開始遊戲時獲得{C:attention}#1#{}"
            }
        }
    }
}
