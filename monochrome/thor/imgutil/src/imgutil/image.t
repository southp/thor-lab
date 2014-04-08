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

    public function getWidth()  : int32;
    public function getHeight() : int32;

    public var _ptr_to_surface : thor.unmanaged.ptr_<int8>;
}

