class Daia extends AIController 
{
    function Start();
}

function Daia::Start()
{
    while (true) {
        AILog.Info("I am a very new AI with a ticker called Daia and I am at tick " + this.GetTick());
        this.Sleep(50);
    }
}