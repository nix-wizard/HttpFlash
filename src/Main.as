package {
    import flash.display.Sprite;

    public class Main extends Sprite {
        function Main() {
            Logger.init(this);
            Logger.log(50);
            Logger.log(<></>.toXMLString());
        }
    }
}