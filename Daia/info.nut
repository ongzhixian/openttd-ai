// 
class Daia extends AIInfo {
    function GetAuthor()      { return "ONG ZHI XIAN"; }
    function GetName()        { return "daia"; }
    function GetDescription() { return "Dummy Artificial Intelligence A - An example AI by following the tutorial at http://wiki.openttd.org/"; }
    function GetVersion()     { return 1; }
    function GetDate()        { return "2020-05-24"; }
    function CreateInstance() { return "Daia"; }
    function GetShortName()   { return "Daia"; }
    function GetAPIVersion()  { return "1.9"; }
}


function GetSettings() 
{
    // Demo of how to add settings
    
    AddSetting({
        name = "bool_setting",
        description = "a bool setting, default off", 
        easy_value = 0, 
        medium_value = 0, 
        hard_value = 0, 
        custom_value = 0, 
        flags = AICONFIG_BOOLEAN
    });

    AddSetting({
        name = "bool2_setting", 
        description = "a bool setting, default on", 
        easy_value = 1, 
        medium_value = 1, 
        hard_value = 1, 
        custom_value = 1, 
        flags = AICONFIG_BOOLEAN
    });

    AddSetting({
        name = "int_setting", 
        description = "an int setting", 
        easy_value = 30, 
        medium_value = 20, 
        hard_value = 10, 
        custom_value = 20, 
        flags = 0, 
        min_value = 1, 
        max_value = 100
    });
}

/* Tell the core we are an AI */
RegisterAI(Daia());