using UAI.ConsoleApp;

namespace UAI.AI.ONNX.FaceParser
{
    public class FaceParserRuntime: Runtime<FaceParserArgumentsOptions>
    {
        public static FaceParserRuntime Instance;
        public static FaceParsing faceParsing;
        public FaceParserRuntime(string[] arguments, bool hasMainLoop = false) : base(arguments)
        {
            this.hasMainLoop = hasMainLoop;
            this._hasMainLoop = hasMainLoop;
            Instance = this;
        }

        public override async Task StartApp()
        {
            await base.StartApp();
            //faceParsing = new FaceParsing(args.modelPath);

            // Start the App

         
        }

        public void LoadModel(string modelPath)
        {
            faceParsing = new FaceParsing(modelPath);
        }


    }
}
