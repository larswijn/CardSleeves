-- Vietnamese by HuyTheLocFixer
return {
    descriptions = {
        Mod = {
            CardSleeves = {
                name = "Bọc Bài",
                text = {
                    "{s:1.3}Thêm {s:1.3,C:attention}15{} {s:1.3,E:1,C:dark_edition}Bọc Bài{} {s:1.3}ở dạng điều chỉnh cho các bộ bài.",
                    " ",
                    "Bao gồm API cho các mod khác",
                    "tự thêm Bọc Bài của riêng chúng.",
                    " ",
                    "Được lập trình và áp dụng bởi {C:blue}Larswijn{}.",
                    "Ý tưởng ban đầu và hình vẽ bởi {C:red}Sable{}.",
                    " ",
                    "{s:1.1}Xem https://github.com/larswijn/CardSleeves để biết thêm thông tin."
                }
            }
        },
        Sleeve = {
            sleeve_casl_none = {
                name = "Không Bọc",
                text = { "Không có điều chỉnh bọc" }
            },

            sleeve_locked = {
                name = "Bị Khoá",
                text = {
                    "Thắng một trận bằng",
                    "{C:attention}#1#{} ở độ khó",
                    "{V:1}#2#{} trở lên"
                }
            },

            sleeve_casl_red = {
                name = "Bọc Đỏ",
                text = G.localization.descriptions.Back["b_red"].text
            },
            sleeve_casl_red_alt = {
                name = "Bọc Đỏ",
                text = {
                    "{C:red}+#1#{} lượt bỏ bài mỗi ván",
                    "",
                    "{C:blue}#2#{} tay bài mỗi ván"
                },
            },

            sleeve_casl_blue = {
                name = "Bọc Lam",
                text = G.localization.descriptions.Back["b_blue"].text
            },
            sleeve_casl_blue_alt = {
                name = "Bọc Lam",
                text = {
                    "{C:blue}+#1#{} tay bài mỗi ván",
                    "",
                    "{C:red}#2#{} lượt bỏ bài mỗi ván"
                },
            },

            sleeve_casl_yellow = {
                name = "Bọc Vàng",
                text = G.localization.descriptions.Back["b_yellow"].text
            },
            sleeve_casl_yellow_alt = {
                name = "Bọc Vàng",
                text = {
                    "Bắt đầu trận với",
                    "phiếu {C:money,T:v_seed_money}#1#{}"
                },
            },

            sleeve_casl_green = {
                name = "Bọc Lục",
                text = G.localization.descriptions.Back["b_green"].text
            },
            sleeve_casl_green_alt = {
                name = "Bọc Lục",
                text = {
                    "Ghi nợ {C:red}$#1#{}",
                    "cho mỗi Tay bài",
                    "và Lượt bỏ bài",
                    "{C:inactive}(Hiện tại là {C:red}-$#2#{C:inactive})"
                }
            },

            sleeve_casl_black = {
                name = "Bọc Đen",
                text = G.localization.descriptions.Back["b_black"].text
            },
            sleeve_casl_black_alt = {
                name = "Bọc Đen",
                text = {
                    "{C:attention}+#1#{} ô Joker",
                    "",
                    "{C:blue}-#2#{} lượt bỏ bài",
                    "mỗi ván"
                }
            },

            sleeve_casl_magic = {
                name = "Bọc Ma Pháp",
                text = G.localization.descriptions.Back["b_magic"].text
            },
            sleeve_casl_magic_alt = {
                name = "Bọc Ma Pháp",
                text = {
                    "Bắt đầu trận với",
                    "phiếu {C:tarot,T:v_omen_globe}#1#{}",
                }
            },

            sleeve_casl_nebula = {
                name = "Bọc Tinh Vân",
                text = G.localization.descriptions.Back["b_nebula"].text
            },
            sleeve_casl_nebula_alt = {
                name = "Bọc Tinh Vân",
                text = {
                    "Bắt đầu trận với",
                    "phiếu {C:planet,T:v_observatory}#1#{}",
                    }
            },

            sleeve_casl_ghost = {
                name = "Bọc Bóng Ma",
                text = G.localization.descriptions.Back["b_ghost"].text
            },
            sleeve_casl_ghost_alt = {
                name = "Bọc Bóng Ma",
                text = {
                    "Tần suất xuất hiện lá {C:spectral}Siêu Linh{}",
                    "ở trong shop được nhân đôi,",
                    "Các {C:spectral}Gói Siêu Linh{} có thêm",
                    "{C:attention}#1#{} lá để chọn",
                }
            },

            sleeve_casl_abandoned = {
                name = "Bọc Bỏ Hoang",
                text = G.localization.descriptions.Back["b_abandoned"].text
            },
            sleeve_casl_abandoned_alt = {
                name = "Bọc Bỏ Hoang",
                text = {
                    "{C:attention}Lá Mặt{} sẽ không còn",
                    "xuất hiện trong trận"
                }
            },

            sleeve_casl_checkered = {
                name = "Bọc Sọc Carô",
                text = G.localization.descriptions.Back["b_checkered"].text
            },
            sleeve_casl_checkered_alt = {
                name = "Bọc Sọc Carô",
                text = {
                    "Mọi lá {C:clubs}Tép{} sẽ biến đổi",
                    "thành lá {C:spades}Bích{} và",
                    "mọi lá {C:diamonds}Rô{} sẽ biến đổi",
                    "thành lá {C:hearts}Cơ{}",
                }
            },

            sleeve_casl_zodiac = {
                name = "Bọc Hoàng Đạo",
                text = G.localization.descriptions.Back["b_zodiac"].text
            },
            sleeve_casl_zodiac_alt = {
                name = "Bọc Hoàng Đạo",
                text = {
                    "Các Gói {C:tarot}Thần Bí{} và {C:planet}Thiên Thể{} đều",
                    "có thêm {C:attention}#1#{} lá để chọn",
                }
            },

            sleeve_casl_painted = {
                name = "Bọc Sơn Màu",
                text = G.localization.descriptions.Back["b_painted"].text
            },
            sleeve_casl_painted_alt = {
                name = "Bọc Sơn Màu",
                text = {
                    "{C:attention}+#1#{} số lá có thể chọn,",
                    "{C:red}#2#{} ô Joker",
                }
            },

            sleeve_casl_anaglyph = {
                name = "Bọc Chạm Nổi",
                text = G.localization.descriptions.Back["b_anaglyph"].text
            },
            sleeve_casl_anaglyph_alt = {
                name = "Bọc Chạm Nổi",
                text = {
                    "Sau khi đánh bại {C:attention}Small Blind{}",
                    "hoặc {C:attention}Big Blind{}, nhận",
                    "một {C:attention,T:tag_double}#1#"
                }
            },

            sleeve_casl_plasma = {
                name = "Bọc Plasma",
                text = G.localization.descriptions.Back["b_plasma"].text
            },
            sleeve_casl_plasma_alt = {
                name = "Bọc Plasma",
                text = {
                    "Cân bằng {C:money}giá tiền{} của mọi",
                    "vật phẩm trong {C:attention}shop{}",
                }
            },

            sleeve_casl_erratic = {
                name = "Bọc Hỗn Loạn",
                text = G.localization.descriptions.Back["b_erratic"].text
            },
            sleeve_casl_erratic_alt = {
                name = "Bọc Hỗn Loạn",
                text = {
                    "Số lượng {C:blue}tay bài{}, {C:red}lượt bỏ bài{},",
                    "{C:money}tiền{} và {C:attention}ô joker{} khởi đầu đều",
                    "ngẫu nhiên trong khoảng từ {C:attention}#1#{} đến {C:attention}#2#{}",
                }
            }
        }
    },
    misc = {
        dictionary = {
            k_sleeve = "Bọc Bài",
            k_sleeves = "Bọc Bài",
            gald_sleeves = "Chọn Bọc",
            gald_random_sleeve = "Bọc Ngẫu Nhiên",
            sleeve_unique_effect_desc = "Một số bọc bài có khả năng riêng biệt khi kết hợp với một số bộ bài nhất định",
            adjust_deck_alignment = "Xếp chồng bài",
            adjust_deck_alignment_desc = {
                "Xếp chồng bài gọn hơn trong trận",
                "để ngăn gây giãn bọc bài",
                "(chỉ ảnh hưởng đến vẻ ngoài)"
            },
            adjust_deck_alignment_options = {
                "Luôn xếp",
                "Khi dùng bọc",
                "Không xếp"
            },
            allow_any_sleeve_selection = "Mở khoá mọi bọc bài",
            allow_any_sleeve_selection_desc = {
                "Cho phép chọn bất kì bọc bài nào từ",
                "màn hình ván mới như thể đã mở khoá"
            },
            sleeve_info_location = "Vị trí thông tin bọc bài",
            sleeve_info_location_desc = {
                "Chọn vị trí hiển thị thông tin bọc bài",
                "như tên và mô tả (chỉ ảnh hưởng đến vẻ ngoài)"
            },
            sleeve_info_location_options = {
                "Chỉ ở Bảng Bộ bài",
                "Chỉ ở T.Tin Trận Này",
                "Xem ở cả hai",
                "Ẩn T.Tin bọc bài"
            },
            sleeve_not_found_error = "Không thể tìm thấy bọc bài! Mod của nó bị gỡ rồi à?",
        },
        v_text = {
            -- for challenges
            ch_m_sleeve = {
                "Bắt đầu với {C:attention}#1#{}"
            }
        }
    }
}
