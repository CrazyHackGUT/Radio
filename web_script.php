<?php
$s = isset($_GET['s']) ? $_GET['s'] : "";
$v = isset($_GET['v']) ? $_GET['v'] : "100";
?>

<audio src="<?=$s?>" autoplay id="hPlayer">

<script type="text/javascript">
    function ParseVolume(volume) {
        return parseFloat(parseInt(volume) / 100);
    }
    window.onhashchange = function (event) {
        Action = location.hash.replace("#", "");
        if (Action[0] == "T") {
            if (Action[5] == "f") {
                hAudioPlayer.volume = 0;
            } else if (Action[5] == "n") {
                hAudioPlayer.volume = Volume;
            }
        } else if (Action[0] == "V" && Action[5] == "e") {
            Volume = ParseVolume(Action.replace("Volume=", ""));
            hAudioPlayer.volume = Volume;
        }
    }
</script>

<script type="text/javascript">
    var Volume = ParseVolume("<?=$v?>");
    var hAudioPlayer = document.getElementById("hPlayer");

    hAudioPlayer.volume = Volume;
</script>
