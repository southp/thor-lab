import .= imgutil;
import .= thor.container;

@entry
task test()
{
    var window = new Window(0, 0);
    var flag = new Flag;
    var options = flag.getRaw();

    if(options.size() != 1)
    {
        println("Usage: thorc r test --args <target PNG path>");
        exit(0);
    }

    var img_path = options.get(0);
    println(img_path);

    var handle_event = lambda() : void{
        if(window.isQuit())
            exit(0);
        else
            window.handleEvent();

        async->handle_event();
    };

    async->handle_event();
}
