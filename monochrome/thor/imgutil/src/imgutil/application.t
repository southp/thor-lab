import thor.unmanaged;

@native
class Application
{
    public function new();
    public function delete();

    public function handleEvent() : void;

    private var _quit : bool;
}

