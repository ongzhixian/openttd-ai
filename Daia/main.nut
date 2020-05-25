class Daia extends AIController 
{
    function Start();

    //property
	town1_id = null;
    town2_id = null;
    has_project = null;
}

function Daia::Start()
{
    AILog.Info("Daia starting.");

    SetCompanyName();

    GetWorldInfo();

    // ListIndustries();

    // ListTowns();
  
    while (true) {

        AILog.Info("Daia at tick " + this.GetTick());

        if (!this.has_project) {
            AILog.Info("No project! Find something to do." );
            
            town1_id = GetLowestPopTownId();
            
            town2_id = GetNearestTownId(town1_id);
    
            LinkTown(town1_id, town2_id);

            this.has_project = true;

        } else {
            AILog.Info("Has project! Continue to work on project." );

            ContinueLinkTown(town1_id, town2_id)
            
            // TestBuild(town1_id, town2_id);
        }

        // HandleEvents();

        this.Sleep(50);
    }
}

function Daia::LinkTown(fromTownId, toTownId)
{
    AILog.Info("Going to connect " + AITown.GetName(fromTownId) + " to " + AITown.GetName(toTownId));
    AILog.Info("Medium is " + AIRoad.GetName(AIRoad.ROADTYPE_ROAD));

    local fromTileIndex = AITown.GetLocation(fromTownId);
    local toTileIndex = AITown.GetLocation(toTownId);
    local routeTileList = AITileList();
}

function Daia::ContinueLinkTown(fromTownId, toTownId)
{
    AILog.Info("Continue connecting " + AITown.GetName(fromTownId) + " to " + AITown.GetName(toTownId));
    local fromTileIndex = AITown.GetLocation(fromTownId);
    local toTileIndex = AITown.GetLocation(toTownId);

    local fromX = AIMap.GetTileX(fromTileIndex);
    local fromY = AIMap.GetTileY(fromTileIndex);
    local toX = AIMap.GetTileX(toTileIndex);
    local toY = AIMap.GetTileY(toTileIndex);

    local xlen = abs(fromX - toX);
    local ylen = abs(fromY - toY);

    AILog.Info("Target build road from x,y (" + fromX + ", " + fromY + ") to x1,y1 (" + toX + ", " + toY + ")");
    AILog.Info("xlen is " + xlen + ", ylen is " + ylen);

    // Build the road in the direction with the lowest Manhanttan distance
    if (xlen <= ylen) {
        AILog.Info("X is shorter. Build in X direction first.");
        BuildXDir(fromX, fromY, toX, toY);
        //BuildYDir(fromX, fromY, toX, toY);
    } else {
        AILog.Info("Y is shorter. Build in Y direction first.");
        //BuildYDir(fromX, fromY, toX, toY);
        //BuildXDir(fromX, fromY, toX, toY);
    }
}

function Daia::BuildXDir(fromX, fromY, toX, toY)
{
    // 
    if (fromX < toX) { // Incr X
        AILog.Info("Incr X");

    } else { // fromX >= toX // Decr X
        AILog.Info("Decr X");

        local xlen = abs(fromX - toX);
        local startX = fromX
        local startY = fromY

        AIRoad.SetCurrentRoadType(AIRoad.ROADTYPE_ROAD);

        for (local i = 0; i < xlen; i += 1) {
            local endX = startX - 1;

            local startTileIndex    = AIMap.GetTileIndex(startX     , startY);
            local endTileIndex      = AIMap.GetTileIndex(endX       , startY);

            local ok = AIRoad.BuildRoad(startTileIndex, endTileIndex);
            if (!ok) {
                break;
            }
            
            AILog.Info("Build ok? [" + ok + "]");
            startX = endX;
        }
    }

}

function Daia::TestBuild(fromTownId, toTownId)
{
    AILog.Info("Continue connecting " + AITown.GetName(fromTownId) + " to " + AITown.GetName(toTownId));
    local fromTileIndex = AITown.GetLocation(fromTownId);

    // Wait, say what?!
    
    // The bottom-most tile accessible to the AI is always (Max_X-2, Max_Y-2)
    // https://wiki.openttd.org/AI:Need_To_Know

    local startTileIndex = AIMap.GetTileIndex(AIMap.GetMapSizeX() - 2, AIMap.GetMapSizeY() - 2);
    local endTileIndex = AIMap.GetTileIndex(AIMap.GetMapSizeX() - 2, AIMap.GetMapSizeY() - 4);

    // AILog.Info("Road type A: " + AIRoad.ROADTYPE_ROAD );    // 0
    // AILog.Info("Road type B: " + AIRoad.ROADTYPE_TRAM );    // 1
    // AILog.Info("Road type C: " + AIRoad.ROADTYPE_INVALID ); // -1
    // AILog.Info("Current road type (before): " + AIRoad.GetCurrentRoadType()); // I have no idea why default is 63?!
    // AIRoad.SetCurrentRoadType(AIRoad.ROADTYPE_ROAD);
    // AILog.Info("Current road type (after): " + AIRoad.GetCurrentRoadType()); // I have no idea why default is 63?!

    AIRoad.SetCurrentRoadType(AIRoad.ROADTYPE_ROAD);
    AILog.Info("Valid build tile " + AIMap.IsValidTile(startTileIndex));
    AILog.Info("Valid front tile " + AIMap.IsValidTile(endTileIndex));
    AILog.Info("Available        " + AIRoad.IsRoadTypeAvailable(AIRoad.GetCurrentRoadType()));
    AILog.Info("Tile             " + startTileIndex + " is buildable " + AITile.IsBuildable(startTileIndex));

    //AIRoad.BuildRoadDepot(startTileIndex, startTileIndex);
    local ok = AIRoad.BuildRoad(startTileIndex, endTileIndex);
    AILog.Info("Build ok? [" + ok + "]");

}

function Daia::GetWorldInfo() 
{
    AILog.Info("Map size is " + AIMap.GetMapSize()); // TileIndex
    AILog.Info("max X is [" + AIMap.GetMapSizeX() + "], max Y is [" + AIMap.GetMapSizeY() + "]");

    local endTileIndex = AIMap.GetTileIndex(AIMap.GetMapSizeX() - 1, AIMap.GetMapSizeY() - 1);

    AILog.Info("Last tile " + endTileIndex);
}

function Daia::ListIndustries() 
{
    local industryTypeList = AIIndustryTypeList();

    foreach (industry_type, value in industryTypeList) 
    {
        // AILog.Info("Industry [xxx] -- Raw:[yes], Processing:[yes], VarProd:[yes]");
        AILog.Info("Industry [" + AIIndustryType.GetName(industry_type) + "] -- Raw:[" + AIIndustryType.IsRawIndustry(industry_type) + "], Processing:[" + AIIndustryType.IsProcessingIndustry(industry_type) + "], VarProd:["+ AIIndustryType.ProductionCanIncrease(industry_type) + "]");
    }

    // Ideally, should write something that maps out industry, accepts and products (chain); KIV for now

}

function MyVal(bridge_id, myparam) { 
    AILog.Info("bridge_id=" + bridge_id + ", myparam=" + myparam);
    return myparam * bridge_id; // This is silly 
} 

function Daia::GetNearestTownId(fromTownId)
{
    local townlist = AITownList();

    // Find town with the smallest Manhattan distance fromTownId
    townlist.Valuate(AITown.GetDistanceManhattanToTile, AITown.GetLocation(fromTownId));
    townlist.KeepAboveValue(0);
    townlist.Sort(townlist.SORT_BY_VALUE, true);
    townlist.KeepTop(1);

    local town_id = townlist.Begin();
    AILog.Info("Nearest town [" + town_id + "] " + AITown.GetName(town_id) + " -- Pop: " + AITown.GetPopulation(town_id) + ", City: " + AITown.IsCity(town_id));

    return town_id;
}

function Daia::GetLowestPopTownId()
{
    local townlist = AITownList();

    townlist.Valuate(AITown.GetPopulation);
    townlist.KeepBelowValue(500);
    townlist.Sort(townlist.SORT_BY_VALUE, true);
    townlist.KeepTop(1);

    /*
    AILog.Info("Count is " + townlist.Count());
    foreach (town_id, value in townlist) 
    {
        AILog.Info("Town [" + town_id + "] " + AITown.GetName(town_id) + " -- Pop: " + AITown.GetPopulation(town_id) + ", City: " + AITown.IsCity(town_id));
    }
    */

    local town_id = townlist.Begin();
    AILog.Info("Smallest town [" + town_id + "] " + AITown.GetName(town_id) + " -- Pop: " + AITown.GetPopulation(town_id) + ", City: " + AITown.IsCity(town_id));
    
    return town_id;
    
}

function Daia::ListTowns()
{
    local townCount = AITown.GetTownCount();
    local townlist = AITownList();

    AILog.Info("there are " + townCount + " towns.");

    townlist.Valuate(AITown.GetPopulation);
    townlist.KeepBelowValue(500); //Rather than take above townlist.KeepAboveValue(500);
    townlist.Sort(townlist.SORT_BY_VALUE, true);

    foreach (town_id, value in townlist) 
    {
        // "Town [00] xxx -- Pop: xxxx, Citi: xxx"
        AILog.Info("Town [" + town_id + "] " + AITown.GetName(town_id) + " -- Pop: " + AITown.GetPopulation(town_id) + ", City: " + AITown.IsCity(town_id));
        
    }
}

function Daia::HandleEvents()
{
    while (AIEventController.IsEventWaiting()) {
        
        local e = AIEventController.GetNextEvent();
    
        switch (e.GetEventType()) {
            case AIEvent.ET_VEHICLE_CRASHED:
                local ec = AIEventVehicleCrashed.Convert(e);
                local v  = ec.GetVehicleID();
                AILog.Info("We have a crashed vehicle (" + v + ")");
                /* TODO: Handle the crashed vehicle */
                break;
        }
    }
}

function Daia::Save()
{
    local table = {};

    // TODO: Add your save data to the table.
    
    return table;
}

function Daia::Load(version, data)
{
    AILog.Info(" Loaded");
    
    // TODO: Add your loading routines.

}

function Daia::SetCompanyName()
{
    if (!AICompany.SetName("Daiya")) {
        local i = 2;

        while (!AICompany.SetName("Testing AI #" + i)) {
            i = i + 1;
            if (i > 255) 
                break;
        }
    }

    AICompany.SetPresidentName("Daiya");
}