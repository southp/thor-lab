
class Window
{
    public function new(x : int32, y : int32)
    {
    }

    public function isQuit() : bool
    {
        static var x : int32 = 0;
        ++x;

        return x > 1000;
    }

    public function handleEvent() : void
    {
    }
}

