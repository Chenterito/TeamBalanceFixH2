init()
{
    // define the auto balance string in the game array (referenced in gsc dump, but not defined past IW6?)
    precachestring(&"MP_AUTOBALANCE_NOW");
    game["strings"]["autobalance"] = &"MP_AUTOBALANCE_NOW";
        
    // define onteamselection callback function used in balanceteams()
    level.onteamselection = ::set_team;
}

main() 
{
    replacefunc(maps\mp\gametypes\_teams::balanceteams, ::balanceteams);
}

balanceteams()
{
    iprintlnbold( game["strings"]["autobalance"] );
    var_0 = [];
    var_1 = [];
    var_2 = level.players;

    for ( var_3 = 0; var_3 < var_2.size; var_3++ )
    {
        if ( !isdefined( var_2[var_3].pers["score"] ) )
            continue;

        if ( isdefined( var_2[var_3].pers["team"] ) && var_2[var_3].pers["team"] == "allies" )
        {
            var_0[var_0.size] = var_2[var_3];
            continue;
        }

        if ( isdefined( var_2[var_3].pers["team"] ) && var_2[var_3].pers["team"] == "axis" )
            var_1[var_1.size] = var_2[var_3];
    }

    var_4 = undefined;

    while ( var_0.size > var_1.size + 1 || var_1.size > var_0.size + 1 )
    {
        if ( var_0.size > var_1.size + 1 )
        {
            for ( var_5 = 0; var_5 < var_0.size; var_5++ )
            {
                if ( isdefined( var_0[var_5].dont_auto_balance ) )
                    continue;

                if ( !isdefined( var_4 ) )
                {
                    var_4 = var_0[var_5];
                    continue;
                }

                if ( var_0[var_5].pers["score"] < var_4.pers["score"] )
                    var_4 = var_0[var_5];
            }

            var_4 [[ level.onteamselection ]]( "axis" );
        }
        else if ( var_1.size > var_0.size + 1 )
        {
            for ( var_5 = 0; var_5 < var_1.size; var_5++ )
            {
                if ( isdefined( var_1[var_5].dont_auto_balance ) )
                    continue;

                if ( !isdefined( var_4 ) )
                {
                    var_4 = var_1[var_5];
                    continue;
                }

                if ( var_1[var_5].pers["score"] < var_4.pers["score"] )
                    var_4 = var_1[var_5];
            }

            var_4 [[ level.onteamselection ]]( "allies" );
        }

        var_4 = undefined;
        var_0 = [];
        var_1 = [];
        var_2 = level.players;

        for ( var_3 = 0; var_3 < var_2.size; var_3++ )
        {
            if ( isdefined( var_2[var_3].pers["team"] ) && var_2[var_3].pers["team"] == "allies" )
            {
                var_0[var_0.size] = var_2[var_3];
                continue;
            }

            if ( isdefined( var_2[var_3].pers["team"] ) && var_2[var_3].pers["team"] == "axis" )
                var_1[var_1.size] = var_2[var_3];
        }
    }
}


set_team(team)
{
    if (team != self.pers["team"])
    {
        self.switching_teams = true;
        self.joining_team = team;
        self.leaving_team = self.pers["team"];
    }

    if (self.sessionstate == "playing")
    {
        self suicide();
    }

    maps\mp\gametypes\_menus::addtoteam(team);
    maps\mp\gametypes\_menus::endrespawnnotify();
}
