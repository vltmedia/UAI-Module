using UAI.AI.ONNX.FaceParser;

// Start the App
FaceParserRuntime runtime = new FaceParserRuntime(args);
await runtime.StartApp();
runtime.LoadModel(FaceParserRuntime.args.modelPath);
FaceParserRuntime.faceParsing.LoadImage(FaceParserRuntime.args.inputPath);
Console.WriteLine("Starting FaceParser");
await FaceParserRuntime.faceParsing.RunOnnxInference();
