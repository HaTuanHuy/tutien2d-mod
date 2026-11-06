using System;
using System.IO;
using System.IO.Compression;

class BuildJar {
    static void Main() {
        string jarPath = "TuTien2D.jar";
        if (File.Exists(jarPath)) File.Delete(jarPath);

        using (FileStream zipStream = new FileStream(jarPath, FileMode.Create))
        using (ZipArchive archive = new ZipArchive(zipStream, ZipArchiveMode.Create)) {
            // Entry 1: META-INF/
            archive.CreateEntry("META-INF/");

            // Entry 2: META-INF/MANIFEST.MF (Phải ở đầu tiên của JAR!)
            var manifestEntry = archive.CreateEntry("META-INF/MANIFEST.MF", CompressionLevel.Optimal);
            using (var writer = new StreamWriter(manifestEntry.Open())) {
                writer.WriteLine("Manifest-Version: 1.0");
                writer.WriteLine("Main-Class: TuTienLauncher");
                writer.WriteLine("");
            }

            // Entry 3: tutien2d-helper.user.js
            if (File.Exists("tutien2d-helper.user.js")) {
                archive.CreateEntryFromFile("tutien2d-helper.user.js", "tutien2d-helper.user.js", CompressionLevel.Optimal);
            }

            // Entry 4: All TuTienLauncher*.class
            foreach (string cf in Directory.GetFiles(".", "TuTienLauncher*.class")) {
                string name = Path.GetFileName(cf);
                archive.CreateEntryFromFile(cf, name, CompressionLevel.Optimal);
            }
        }
        Console.WriteLine("Built valid JAR successfully!");
    }
}

