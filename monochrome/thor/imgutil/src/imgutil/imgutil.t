
@native
class Window
{
    public function new(x : int32, y : int32);
    public function delete();

    public function isQuit() : bool;

    public function handleEvent() : void;
}

