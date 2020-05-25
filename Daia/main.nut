class Daia extends AIController 
{
    function Start();
}

function Daia::Start()
{
    AILog.Info("Daia starting.");

    SetCompanyName();

    // ListIndustries();
    
    // ListTowns();

    local town1_id = GetLowestPopTownId();
    local town2_id = GetNearestTownId(town1_id);

    LinkTown(town1_id, town2_id);
  
    while (true) {
        AILog.Info("Daia at tick " + this.GetTick());

        // HandleEvents();

        this.Sleep(50);
    }
}

function Daia::LinkTown(fromTownId, toTownId)
{
    AILog.Info("Going to connect " + AITown.GetName(fromTownId) + " to " + AITown.GetName(toTownId));

    AILog.Info("Medium is " + AIRoad.GetName(AIRoad.ROADTYPE_ROAD));

    AILog.Info("Layout from is " + AITown.GetRoadLayout(fromTownId) + ", to is " + AITown.GetRoadLayout(toTownId));

    //AITown.GetRoadLayout(fromTownId);
    //AITown.GetRoadLayout(fromTownId);

    local fromTileIndex = AITown.GetLocation(fromTownId);
    local toTileIndex = AITown.GetLocation(toTownId);
    local routeTileList = AITileList();

    routeTileList.AddRectangle(fromTileIndex, toTileIndex);

    AILog.Info("Route tiles count is " + routeTileList.Count());

    AILog.Info("fromTileIndex " + fromTileIndex);

    //AILog.Info("Tile " + fromTileIndex + " is buildable " + AITile.IsBuildable(fromTileIndex));
    //AILog.Info("Tile " + toTileIndex + " is buildable " + AITile.IsBuildable(toTileIndex));

    routeTileList.Valuate(AITile.GetDistanceManhattanToTile, AITown.GetLocation(toTownId));
    routeTileList.KeepAboveValue(0);
    routeTileList.Sort(routeTileList.SORT_BY_VALUE, true);
    //routeTileList.KeepTop(1);
    
    foreach (tile_id, value in routeTileList) 
    {
        if (AITile.IsBuildable(tile_id))
        {
            AILog.Info("Tile " + tile_id + " is buildable " + AITile.IsBuildable(tile_id));

            AIRoad.BuildRoad(fromTileIndex, tile_id);
        }
        // We don't care about tiles that are not buildable
    }
*/
    /*
    townlist.Valuate(AITown.GetDistanceManhattanToTile, AITown.GetLocation(fromTownId));
    townlist.KeepAboveValue(0);
    townlist.Sort(townlist.SORT_BY_VALUE, true);
    townlist.KeepTop(1);
    */
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