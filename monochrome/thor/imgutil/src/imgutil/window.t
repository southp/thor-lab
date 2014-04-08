import thor.unmanaged;

@native
class Window
{
    public function new();
    public function delete();

    public function isQuit() : bool;

    public function handleEvent() : void;

    public function showImage(img : Image) : void;

    private var _ptr_to_window  : thor.unmanaged.ptr_<int8>;
    private var _ptr_to_render  : thor.unmanaged.ptr_<int8>;
    private var _ptr_to_texture : thor.unmanaged.ptr_<int8>;
}

