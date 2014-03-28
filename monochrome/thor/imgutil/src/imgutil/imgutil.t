import thor.unmanaged;

@native
class Window
{
    public function new(x : int32, y : int32);
    public function delete();

    public function isQuit() : bool;

    public function handleEvent() : void;

    private var _ptr_to_window : thor.unmanaged.ptr_<int8>;
    private var _ptr_to_render : thor.unmanaged.ptr_<int8>;
}

@native
function initialize() : bool;

@native
function finalize() : void;
