using UAI.AI.ONNX.FaceParser;

// Start the App
FaceParserRuntime runtime = new FaceParserRuntime(args);
await runtime.StartApp();

FaceParserRuntime.faceParsing.LoadImage(FaceParserRuntime.args.inputPath);
runtime.LoadModel(FaceParserRuntime.args.modelPath);
Console.WriteLine("Starting FaceParser");
await FaceParserRuntime.faceParsing.RunOnnxInference();
