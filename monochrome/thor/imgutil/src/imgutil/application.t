import thor.unmanaged;

@native
class Application
{
    public function new();
    public function delete();

    public function handleEvent() : void;

    public function isQuit() : bool;

    private var _quit : bool;
}

