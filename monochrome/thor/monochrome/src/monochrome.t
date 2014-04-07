import .= imgutil;
import .= thor.container;

function monochrome(img : Image)
{
    var pixs : Vector<int32> = img.getAllPixels();

    for(var i = 0; i < pixs.size(); ++i)
    {
        var p : int32 = pixs.get(i);
        var r : float32 = (p & 0xFF) / 255.0;
        var g : float32 = ((p >> 8) & 0xFF) / 255.0;
        var b : float32 = ((p >> 16) & 0xFF) / 255.0;
        var a : int32 = p & 0xFF000000;

        var mono : float32 = (0.2125 * r) + (0.7154 * g) + (0.0721 * b);
        var mono_int : int32 = cast<int32>(mono * 255);
        var final : int32 = a | mono_int | (mono_int << 8) | (mono_int << 16);

        pixs.set(i, final);
    }

    img.setAllPixels(pixs);
}


task mono_pixel(pixs : Vector<int32>, i : int32)
{
    if(i == pixs.size())
        return;

    var job = lambda() : void
    {
        var p : int32 = pixs.get(i);
        var r : float32 = (p & 0xFF) / 255.0;
        var g : float32 = ((p >> 8) & 0xFF) / 255.0;
        var b : float32 = ((p >> 16) & 0xFF) / 255.0;
        var a : int32 = p & 0xFF000000;

        var mono : float32 = (0.2125 * r) + (0.7154 * g) + (0.0721 * b);
        var mono_int : int32 = cast<int32>(mono * 255);
        var final : int32 = a | mono_int | (mono_int << 8) | (mono_int << 16);

        pixs.set(i, final);
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

@entry
task test()
{
    if(!initialize())
    {
        println("Failed to initialize!");
        exit(-1);
    }

    var window = new Window(0, 0);
    var flag = new Flag;
    var options = flag.getRaw();

    if(options.size() != 1)
    {
        println("Usage: thorc r test --args <target PNG path>");
        exit(0);
    }

    var img      : Image  = new Image();
    var img_path : String = options.get(0);

    println(img_path);
    if(!img.load(img_path))
    {
        println("Failed to load image: \{img_path}");
        exit(-2);
    }

    /*monochrome(img);*/
    flow ->
    {
        async_monochrome(img);
    }

    window.showImage(img);

    var handle_event = lambda() : void{
        if(window.isQuit())
        {
            finalize();
            exit(0);
        }
        else
            window.handleEvent();

        async->handle_event();
    };

    async->handle_event();
}
