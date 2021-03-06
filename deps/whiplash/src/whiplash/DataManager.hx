package whiplash;

import js.Browser.document;

#if embed
@:build(whiplash.Macro.embedData())
#end
class DataManager {
    public static var textureFiles:Array<String> = Macro.getDataFilePaths("textures");
    public static var soundFiles:Array<String> = Macro.getDataFilePaths("sounds");
    public static var tilemapFiles:Array<String> = Macro.getDataFilePaths("tilemaps");
    public static var atlasFiles:Array<String> = Macro.getDataFilePaths("atlases");

    static public function preload(game:phaser.Game) {
#if phaser
#if embed
        var nodes = document.querySelectorAll(".texture");

        for(node in nodes) {
            var el:js.html.Element = cast node;
            game.cache.addImage(el.id, null, node);
        }

#end

        if(game != null) {
            for(file in textureFiles) {
                var name = new haxe.io.Path(file).file;
#if !embed
                game.load.image(name, file);
#end
            }

            for(file in soundFiles) {
                var name = new haxe.io.Path(file).file;
#if !embed
                game.load.audio(name, file);
#end
            }

            for(file in tilemapFiles) {
                var name = new haxe.io.Path(file).file;
#if embed
                game.load.tilemap(name, cast null, untyped $global.jsons[name], cast phaser.Tilemap.TILED_JSON);
#else
                game.load.tilemap(name, cast file, cast null, cast phaser.Tilemap.TILED_JSON);
#end
            }

            for(file in atlasFiles) {
                var path = new haxe.io.Path(file);

                if(path.ext == "json") {
                    var name = path.file;
#if embed
                    throw ":TODO:";
#else
                    game.load.atlas(name, haxe.io.Path.withExtension(file, "png"), file);
#end
                }
            }
        }

#end
    }

    static public function preloadFont(fontFamily) {
        var font = untyped __js__("new FontFaceObserver(fontFamily)");
        font.load(null, 10000).then(function() {
            trace('Font-family loaded: ' + fontFamily);
        });
    }
}
