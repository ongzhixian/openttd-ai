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

/* Tell the core we are an AI */
RegisterAI(Daia());