import .= imgutil;
import .= thor.container;

/////////////////////// Some house-keeping code ///////////////////////////

var g_app    : Application = null;
var g_window : Window = null;
var g_img    : Image  = null;

function init_and_load_image()
{
    g_app    = new Application();
    g_window = new Window();
    g_img    = new Image;

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
    var handle_event = lambda() : void
    {
        if(g_app.isQuit())
            exit(0);
        else
            g_app.handleEvent();

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

/*task mono_pixel(pixs : Vector<int32>, i : int32)*/
/*{*/
/*    if(i == pixs.size())*/
/*        return;*/
/**/
/*    var job = lambda() : void*/
/*    {*/
/*        var p : int32 = pixs.get(i);*/
/*        var mono_p = mono_value(p);*/
/**/
/*        pixs.set(i, mono_p);*/
/*    };*/
/**/
/*    flow ->*/
/*    {*/
/*        job();*/
/*        mono_pixel(pixs, ++i);*/
/*    }*/
/*}*/

var total_pixel : int32 = 0;
var counter     : int32 = 0;

task async_pixel_monochrome(img : Image)
{
    var pixs : Vector<int32> = img.getAllPixels();

    total_pixel = pixs.size();
    for(var i = 0; i < total_pixel; ++i)
    {
        async ->
        {
            var p      : int32 = pixs.get(i);
            var mono_p : int32 = mono_value(p);

            pixs.set(i, mono_p);

            atomic ->
            {
                ++counter;
            }
        }
    }

    var check_finish = lambda() : void
    {
        var finish : bool = false;

        atomic ->
        {
            finish = counter == total_pixel;
        }

        if(finish)
        {
            img.setAllPixels(pixs);
            show_result();
        }
        else
        {
            async -> check_finish();
        }
    };

    async -> check_finish();
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
        mono_segment(pixs,         0    , total / 4    );
        mono_segment(pixs, total / 4    , total / 2    );
        mono_segment(pixs, total / 2    , total * 3 / 4);
        mono_segment(pixs, total * 3 / 4, total        );
    }

    img.setAllPixels(pixs);
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

    async -> async_pixel_monochrome(g_img);

    // show_result();
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

