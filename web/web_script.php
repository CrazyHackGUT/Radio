<?php
/**
 * Init vars
 */
$engine     = isset($_GET['engine']) ? $_GET['engine'] : "orangebox";
$volume     = isset($_GET['volume']) ? floatval(intval($_GET['volume'])) / 100 : 1.0;
$station    = isset($_GET['station']) ? $_GET['station'] : "";

/**
 * Small changes in vars.
 */
$volume = floatval($volume);

/**
 * Select content type.
 */
if ($_GET['engine'] == "old") {
?><!-- Counter-Strike: Source v34 -->
<object type="application/x-shockwave-flash" data="player.swf" width="1" height="1">
    <param name="movie" value="player.swf" />
    <param name="AllowScriptAccess" value="always" />
    <param name="FlashVars" value="mp3=<?= $station; ?>&autoplay=1&volume=<?= intval($volume * 100); ?>" />
</object>
<?php } else {
?><!-- Orange Box / CSGO -->
<audio id="hPlayer" autoplay></audio>

<script type="text/javascript">
    var hAudioPlayer = document.getElementById("hPlayer");
<?php if ($engine == "csgo") { ?>
    hAudioPlayer.volume = <?= $volume; ?>;
    hAudioPlayer.src    = "<?= $station; ?>";
<?php } else if ($engine == "orangebox") { ?>
    var Volume = 1.0;

    function ParseVolume(volume) {
        return parseFloat(parseInt(volume) / 100);
    }
    window.onhashchange = function (event) {
        location.hash.replace("#", "").split("&").forEach(function(Action, i, Actions) {
            if (Action[0] == "V" && Action[5] == "e") {
                Volume = ParseVolume(Action.replace("Volume=", ""));
                hAudioPlayer.volume = Volume;
            } else if (Action[0] == "S") {
                src = Action.replace("Station=", "");
                if (src != hAudioPlayer.src)
                    hAudioPlayer.src = src;
            }
        });
    }

    window.onhashchange(null);
<?php } ?>
</script><?php
}
