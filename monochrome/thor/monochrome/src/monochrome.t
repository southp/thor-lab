import .= imgutil;
import .= thor.container;

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
    img.load(img_path);

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
