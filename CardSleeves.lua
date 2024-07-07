--- STEAMODDED HEADER
--- MOD_NAME: Card Sleeves
--- MOD_ID: CardSleeves
--- MOD_AUTHOR: [LarsWijn]
--- MOD_DESCRIPTION: Adds sleeves as modifier to decks.
--- LOADER_VERSION_GEQ: 1.0.0

----------------------------------------------
------------MOD CODE -------------------------

function debug_print(...)
    return sendDebugMessage(table.concat({...}, "\t"), "CardSleeves")
end

SMODS.Atlas{
    key = "sleeve_atlas",
    path = "sleeves.png",  -- only contains blue sleeve for now
    px = 71,
    py = 95
}

SMODS.Sleeves = {}
SMODS.Sleeve = SMODS.GameObject:extend {
    obj_table = SMODS.Sleeves,
    obj_buffer = {},
    class_prefix = "sleeve",
    discovered = false,
    unlocked = true,
    set = "Sleeve",
    atlas = "sleeve_atlas",
    pos = {x = 0, y = 0},  -- within `atlas`
    injected = false,
    required_params = {"key", "atlas", "pos"},
    inject_class = function(self)
                   G.P_CENTER_POOLS[self.set] = {}
                   G.P_SLEEVES = {}
                   SMODS.Sleeve.super.inject_class(self)
                   end,
    inject = function(self)
             G.P_CENTER_POOLS[self.key] = G.P_CENTER_POOLS[self.key] or {}
             G.localization.descriptions[self.key] = G.localization.descriptions[self.key] or {}
             end,
    process_loc_text = function(self)
                       return "???"
                       end
}

SMODS.Sleeve{
    key = "none",
    name = "No Sleeve",
    config = {hands = 1},
    loc_txt = {
        name = "No Sleeve",
        text = {""}
    },
    atlas = "jokers",
    pos = {x=0, y=9}
}

SMODS.Sleeve{
    key = "blue",
    name = "Blue Sleeve",
    config = {hands = 1},
    loc_txt = {
        name = "Blue Sleeve",
        text = {"{C:blue}+#1#{} hand", "every round"}
    },
    loc_vars = function(self)
        return {vars = {self.config.hands}}
    end,
    atlas = "sleeve_atlas",
    pos = {x=0, y=0}
}

old_run_setup_option = G.UIDEF.run_setup_option

G.FUNCS.change_sleeve = function(args)
    G.viewed_sleeve = args.to_key
    G.PROFILES[G.SETTINGS.profile].MEMORY.sleeve = args.to_key
end

G.FUNCS.RUN_SETUP_check_sleeve = function(e)
    if (G.GAME.viewed_back.name ~= e.config.id) then 
        e.config.object:remove() 
        e.config.object = UIBox{
          definition =  G.UIDEF.sleeve_option(G.SETTINGS.current_setup),
          config = {offset = {x=0,y=0}, align = 'tmi', parent = e}
        }
        e.config.id = G.GAME.viewed_back.name
    end
end

G.FUNCS.RUN_SETUP_check_sleeve2 = function(e)
    if (G.viewed_sleeve ~= e.config.id) then 
        e.config.object:remove() 
        e.config.object = UIBox{
          definition =  G.UIDEF.viewed_sleeve_option(),
          config = {offset = {x=0,y=0}, align = 'cm', parent = e}
        }
        e.config.id = G.viewed_sleeve
    end
end

function G.UIDEF.sleeve_description(_sleeve)
    local _sleeve_center = G.P_CENTER_POOLS.Sleeve[_sleeve]
    local ret_nodes = {}
    if _sleeve_center then localize{type = 'descriptions', key = _sleeve_center.key, set = _sleeve_center.set, nodes = ret_nodes} end 

    local desc_t = {}
    for k, v in ipairs(ret_nodes) do
        desc_t[#desc_t+1] = {n=G.UIT.R, config={align = "cm", maxw = 5.3}, nodes=v}
    end
    
    
    return {n=G.UIT.C, config={align = "cm", padding = 0.05, r = 0.1, colour = G.C.L_BLACK}, nodes={
    {n=G.UIT.R, config={align = "cm", padding = 0}, nodes={
      {n=G.UIT.T, config={text = "text", scale = 0.35, colour = G.C.WHITE}}
    }},
    {n=G.UIT.R, config={align = "cm", padding = 0.03, colour = G.C.WHITE, r = 0.1, minh = 1, minw = 5.5}, nodes=desc_t}
    }}
end

function G.UIDEF.sleeve_option(_type)
    local middle = {n=G.UIT.R, config={align = "cm", minh = 1.7, minw = 7.3}, nodes={
    {n=G.UIT.O, config={id = nil, func = 'RUN_SETUP_check_sleeve2', object = Moveable()}},
    }}
    local sleeve_options = {[1] = "None", [2] = "Blue Sleeve"}

    return  {n=G.UIT.ROOT, config={align = "tm", colour = G.C.CLEAR, minh = 2.03, minw = 8.3}, nodes={_type == 'Continue' and middle or create_option_cycle({options = 
    sleeve_options, opt_callback = 'change_sleeve', current_option = G.viewed_sleeve, colour = G.C.RED, w = 6, mid = middle
    })}}
end

function G.UIDEF.viewed_sleeve_option()
    G.viewed_sleeve = G.viewed_sleeve or 1
    if _type ~= 'Continue' then G.PROFILES[G.SETTINGS.profile].MEMORY.sleeve = G.viewed_sleeve end

    -- TODO: update sleeve around cards?

    return {n=G.UIT.ROOT, config={align = "cm", colour = G.C.BLACK, r = 0.1}, nodes={
    {n=G.UIT.C, config={align = "cm", padding = 0}, nodes={
      {n=G.UIT.T, config={text = "Sleeve", scale = 0.4, colour = G.C.L_BLACK}}
    }},
    {n=G.UIT.C, config={align = "cm", padding = 0.1}, nodes={
      G.UIDEF.sleeve_description(G.viewed_sleeve)
    }}
    }}
end

function new_run_setup_option(_type)
    -- wrap `run_setup_option` with our own func
    output = old_run_setup_option(_type)
    debug_print("called run_setup_option!")
    local scale = 0.5
    --[[
    nodes = 
    [
        RUN_SETUP_check_back, RUN_SETUP_check_bake_stake_column,
        RUN_SETUP_check_stake=
        [
            stake_object
        ],
        toggle_seeded_run,
        [input_seed, button_play]
    ]
    --]]
    output.nodes[5] = output.nodes[4]
    output.nodes[4] = output.nodes[3]
    if _type == "Continue" then
        output.nodes[3] = {n=G.UIT.R, 
                           config={align="cm"}, 
                           nodes={
                                  {n=G.UIT.T, 
                                   config={text="Text", colour=G.C.UI.TEXT_LIGHT, scale=scale*0.8}
                                   }
                           }
        }
    elseif _type == "New Run" then
        output.nodes[3] = {n=G.UIT.R, 
                           config={align="cm", minh=2.2, minw=6.8}, 
                           nodes={
                                  {n=G.UIT.O, 
                                   config={id=nil, func='RUN_SETUP_check_sleeve', insta_func = true, object = Moveable()}
                                   }
                                  }
                           }
    end
    return output
end

G.UIDEF.run_setup_option = new_run_setup_option

old_RUN_SETUP_check_back = G.FUNCS.RUN_SETUP_check_back

function new_RUN_SETUP_check_back(e)
    if G.GAME.viewed_back.name ~= e.config.id then
        -- debug_print("Deck change! current deck is " .. G.GAME.viewed_back.name .. "!")
    end
    return old_RUN_SETUP_check_back(e)
end

G.FUNCS.RUN_SETUP_check_back = new_RUN_SETUP_check_back

----------------------------------------------
------------MOD CODE END----------------------
