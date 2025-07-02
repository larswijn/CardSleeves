# ![icon](assets/1x/icon.png) CardSleeves
CardSleeves is a Balatro mod using Steamodded + Lovely that introduces 15 unique Sleeves, each based on one of the game's decks. Sleeves act as run modifiers, allowing players to mix and match effects from any deck and sleeve — effectively playing with the abilities of two decks at once.

![Balatro_Card_Sleeves](Balatro_Card_Sleeves.png)

# Requirements
- Requires `Steamodded >= 1.0.0~ALPHA-1424a` - [link](https://github.com/Steamodded/smods/wiki).
- Requires `Lovely >= 0.6.0` - [link](https://github.com/ethangreen-dev/lovely-injector). This should already be installed as part of steamodded's installation process.

# Installation
1. Download the latest stable version from the [Releases page](https://github.com/larswijn/CardSleeves/releases/latest).
2. Extract the ZIP file.
3. Place the `CardSleeves` folder directly into your `Mods` directory (make sure it is not nested, i.e. that there is a single folder between the mods folder and the contents).

Alternatively, use `git clone` for the latest development code, which is more up-to-date, but might be unstable.

# Features
Sleeves are run modifiers that are selected at the start of a run, just like decks. Each run can have one deck and one sleeve, and any deck and sleeve can be combined. Some combinations of deck & sleeve also have special effects!

CardSleeves adds 15 Sleeves by default, all of which have a different effect when paired with their corresponding deck:
| **Sleeve**       | **Base effect**                                        | **Unique effect**                                                      |
|------------------|--------------------------------------------------------|------------------------------------------------------------------------|
| Red Sleeve       | +1 discard                                             | +1 discard, -1 hand                                                    |
| Blue Sleeve      | +1 hand                                                | +1 hand, -1 discard                                                    |
| Yellow Sleeve    | +$10                                                   | Seed Money Voucher                                                     |
| Green Sleeve     | +$1 per remaining hand/discard                         | Can go up to -$2 in debt for every hand and discard                    |
| Black Sleeve     | +1 joker slot, -1 hand                                 | +1 joker slot, -1 discard                                              |
| Magic Sleeve     | Crystal Ball Voucher, 2 Fools                          | Omen Globe Voucher                                                     |
| Nebula Sleeve    | Telescope Voucher, -1 consumable slot                  | Observatory Voucher                                                    |
| Ghost Sleeve     | Spectral cards appear in shop, Hex card                | Spectrals appear more often in shop, Spectral pack size increases by 2 |
| Abandoned Sleeve | No Face Cards in starting deck                         | Face Cards never appear                                                |
| Checkered Sleeve | 26 Spades and 26 Hearts in starting deck               | Only Spades and Hearts appear                                          |
| Zodiac Sleeve    | Tarot Merchant, Planet Merchant and Overstock Vouchers | Arcana/Celestial pack size increases by 2                              |
| Painted Sleeve   | +2 hand size, -1 joker slot                            | +1 card selection limit, -1 joker slot                                 |
| Anaglyph Sleeve  | Double Tag after each Boss Blind                       | Double Tag after each Small/Big Blind                                  |
| Plasma Sleeve    | Balance chips/mult, X2 base Blind size                 | Balance prices in shop                                                 |
| Erratic Sleeve   | All ranks/suits in starting deck are randomized        | Starting Hands/Discards/Dollars/Joker slots are randomized between 3-6 |

Other mods have the ability to add their own Sleeves! Some of these mods include:
+ [Cryptid](https://github.com/SpectralPack/Cryptid)
+ [Pokermon](https://github.com/InertSteak/Pokermon)
+ [SDM_0's Stuff](https://github.com/SDM0/SDM_0-s-Stuff)
+ [MoreFluff](https://github.com/notmario/MoreFluff)
+ [Familiar](https://github.com/RattlingSnow353/Familiar)
+ [Cardsauce](https://github.com/BarrierTrio/Cardsauce)
+ [Aikoyori's Shenanigans](https://github.com/Aikoyori/Balatro-Aikoyoris-Shenanigans)
+ And more! See the [modded balatro wiki entry](https://balatromods.miraheze.org/wiki/CardSleeves) for a more extensive list of cross-mod entries

CardSleeves also has support for [Galdur](https://github.com/Eremel/Galdur)'s improved new run menu!

# Feedback
Suggestions, improvements, or bug reports are welcome and can be submitted through Github's Issues, or on the Balatro Discord [Thread](https://discord.com/channels/1116389027176787968/1279246553931976714).

# API (for mod developers)
Any other mod can create new sleeves. See [the wiki](https://github.com/larswijn/CardSleeves/wiki) for more information.

# Credits
Big thanks to Sable for the original idea and the original art, all the cool people who helped translate, and the amazing balatro modding community for helping out with the Lua code.
<details><summary>Localization credits</summary>
🇨🇳 (Traditional) Chinese by Mr. Clover and Dimserene <br/>
🇫🇷 French by Miser and Guigui <br/>
🇩🇪 German by Onichama and Phrog <br/>
🇵🇱 Polish by avandemortell2137 <br/>
🇵🇹 Portuguese (Brazil) by PinkMaggit <br/>
🇷🇺 Russian by EnderDrag0n and Astryder <br/>
🇪🇸 Spanish by Batolol and Yamper <br/>
🇻🇳 Vietnamese by HuyTheLocFixer <br/>
</details>
