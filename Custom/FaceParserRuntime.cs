using UAI.ConsoleApp;

namespace UAI.AI.ONNX.FaceParser
{
    public class FaceParserRuntime: Runtime<FaceParserArgumentsOptions>
    {
        public static FaceParserRuntime Instance;
        public static FaceParsing faceParsing;
        public FaceParserRuntime(string[] arguments) : base(arguments)
        {
            Instance = this;
        }

        public override async Task StartApp()
        {
            await base.StartApp();
            faceParsing = new FaceParsing(args.modelPath);
            faceParsing.LoadImage(args.inputPath);
            Console.WriteLine("Starting FaceParser");

            await faceParsing.RunOnnxInference();
            // Start the App

         
        }


    }
}
