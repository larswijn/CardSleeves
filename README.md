# ![icon](assets/1x/icon.png) CardSleeves
A Steamodded+lovely Balatro Mod that adds Sleeves.

![Balatro_Card_Sleeves](Balatro_Card_Sleeves.png)

# Requirements
Requires `steamodded >= 1.0.0~ALPHA-1206c` - [link](https://github.com/Steamodded/smods/wiki).

Requires `Lovely >= 0.6.0` - [link](https://github.com/ethangreen-dev/lovely-injector). This should already be installed as part of steamodded's installation process, but might need to be updated to version 0.6.0 or later.

# Installation
Get the latest stable version from the [Releases](https://github.com/larswijn/CardSleeves/releases/latest), then download and extract the zip.
Or use `git clone` for the latest development code, which is more up-to-date, but might be unstable.

Make sure to put the `CardSleeves` folder in the `Mods` directory, and that it is not nested.

# Features
Sleeves are run modifiers similar to decks. Any deck and sleeve can be combined.

CardSleeves adds 15 Sleeves by default, some of which have an unique and different effect when paired with their corresponding deck:
| Sleeve           | Base effect                                            | Unique effect                                                          |
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
+ [Cryptid](https://github.com/MathIsFun0/Cryptid)
+ [Familiar](https://github.com/RattlingSnow353/Familiar)
+ [SDM_0's Stuff](https://github.com/SDM0/SDM_0-s-Stuff)
+ [MoreFluff](https://github.com/notmario/MoreFluff)
+ [Reverie](https://github.com/dvrp0/reverie)
+ [Pokermon](https://github.com/InertSteak/Pokermon)
+ [Buffoonery](https://github.com/pinkmaggit-hub/Buffoonery)
+ [Balatro Drafting](https://github.com/spire-winder/Balatro-Draft)
+ [Themed Jokers](https://github.com/cerloCasa/Themed-Jokers)
+ [Jimbo's Pack](https://github.com/art-muncher/Jimbo-s-Pack)
+ And more!

CardSleeves also has support for [Galdur](https://github.com/Eremel/Galdur)'s improved new run menu!

# API (for mod developers)
Any other mod can create new sleeves. See [the wiki](https://github.com/larswijn/CardSleeves/wiki) for more information.

# Credits
Big thanks to Sable for the original idea and the original art, all the cool people who helped translate, and the amazing balatro modding community for helping out with the lua code.

Any suggestions, improvements or bugs are welcome and can be submitted through Github's Issues, or on the Balatro Discord [Thread](https://discord.com/channels/1116389027176787968/1279246553931976714).
