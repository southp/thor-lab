import thor.unmanaged;
import thor.container;

@native
class Image
{
    public function new();
    public function delete();

    public function load(filename : String) : bool;

    public function getAllPixels() : thor.container.Vector<int32>;
    public function setAllPixels(pixs : thor.container.Vector<int32>);

    public var _ptr_to_surface : thor.unmanaged.ptr_<int8>;
}


@native
class Window
{
    public function new(x : int32, y : int32);
    public function delete();

    public function isQuit() : bool;

    public function handleEvent() : void;

    public function showImage(img : Image) : void;

    private var _ptr_to_window : thor.unmanaged.ptr_<int8>;
    private var _ptr_to_render : thor.unmanaged.ptr_<int8>;
    private var _quit : bool;
}

@native
function initialize() : bool;

@native
function finalize() : void;
