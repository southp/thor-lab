import .= imgutil;
import .= thor.container;

/////////////////////// Some house-keeping code ///////////////////////////

var g_window : Window = null;
var g_img    : Image  = null;

function init_and_load_image()
{
    if(!initialize())
    {
        println("Failed to initialize!");
        exit(-1);
    }

    g_window = new Window(0, 0);
    g_img = new Image;
    var flag = new Flag;
    var options = flag.getRaw();

    if(options.size() != 1)
    {
        println("Usage: thorc r test --args <target PNG path>");
        exit(0);
    }

    var img_path : String = options.get(0);

    println(img_path);
    if(!g_img.load(img_path))
    {
        println("Failed to load image: \{img_path}");
        exit(-2);
    }
}

task event_loop()
{
    var handle_event = lambda() : void{
        if(g_window.isQuit())
        {
            finalize();
            exit(0);
        }
        else
            g_window.handleEvent();

        async->handle_event();
    };

    async->handle_event();
}

function show_result()
{
    g_window.showImage(g_img);

    async->event_loop();
}
/////////////////////// End of sme house-keeping code ///////////////////////////

/////////////////////// Monochrome implementation //////////////////////////////

function mono_value(p : int32)
{
    var r : float32 = (p & 0xFF) / 255.0;
    var g : float32 = ((p >> 8) & 0xFF) / 255.0;
    var b : float32 = ((p >> 16) & 0xFF) / 255.0;
    var a : int32 = p & 0xFF000000;

    var mono : float32 = (0.2125 * r) + (0.7154 * g) + (0.0721 * b);
    var mono_int : int32 = cast<int32>(mono * 255);

    var final : int32 = a | mono_int | (mono_int << 8) | (mono_int << 16);

    return final;
}

/////// Single function
function monochrome(img : Image)
{
    var pixs : Vector<int32> = img.getAllPixels();

    for(var i = 0; i < pixs.size(); ++i)
    {
        var p : int32 = pixs.get(i);
        var mono_p : int32 = mono_value(p);

        pixs.set(i, mono_p);
    }

    img.setAllPixels(pixs);
}

/////// Async per pixel
task mono_pixel(pixs : Vector<int32>, i : int32)
{
    if(i == pixs.size())
        return;

    var job = lambda() : void
    {
        println("mono_pixel: \{i}");

        var p : int32 = pixs.get(i);
        var mono_p = mono_value(p);

        pixs.set(i, mono_p);
    };

    flow->
    {
        job();
        mono_pixel(pixs, ++i);
    }
}

task async_monochrome(img : Image)
{
    var pixs : Vector<int32> = img.getAllPixels();

    var size = pixs.size();
    println("total pixels: \{size}");

    flow ->
    {
        mono_pixel(pixs, 0);
    }

    img.setAllPixels(pixs);
}

/////// Async per given segment
task mono_segment(pixs : Vector<int32>, beg : int32, end : int32)
{
    for(var i = beg; i != end; ++i)
    {
        var p = pixs.get(i);
        var mono_p = mono_value(p);

        pixs.set(i, mono_p);
    }
}

task async_segment_monochrome(img : Image)
{
    var pixs : Vector<int32> = img.getAllPixels();
    var total = pixs.size();

    flow ->
    {
        mono_segment(pixs,         0, total / 4);
        mono_segment(pixs, total / 4, total / 2);
        mono_segment(pixs, total / 2, total    );
    }
}

@entry
task mono_function()
{
    init_and_load_image();

    monochrome(g_img);

    show_result();
}

@entry
task mono_async_per_pixel()
{
    init_and_load_image();

    flow ->
    {
        async_monochrome(g_img);
    }

    show_result();
}

@entry
task mono_async_per_segment()
{
    init_and_load_image();

    flow ->
    {
        async_segment_monochrome(g_img);
    }

    show_result();
}

