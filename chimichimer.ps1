$host.ui.RawUI.WindowTitle = "chimi chimer"

if ($args.length -eq 0) {
    write-host "You need to put a parameter. E.g.: .\script.ps1 20"  -ForegroundColor Red;
    exit;
}

$mins = $args[0];

$sound = new-Object System.Media.SoundPlayer;
$sound.SoundLocation = "c:\WINDOWS\Media\Windows Pop-up Blocked.wav";
$sound.Play();

#clear-host
write-host "Heard something?"  -ForegroundColor Yellow;

write-host "Waiting $mins minutes (ctrl+c to cancel)"

$now = get-date;
$alarm = (get-date).AddMinutes($mins);

while ($now -lt $alarm) {    
    $now = get-date;
    $newMinsRemaining = [Math]::ceiling(($alarm - $now).TotalMinutes);
    if ($minsRemaining -ne $newMinsRemaining) {
        $minsRemaining = $newMinsRemaining
        $host.ui.RawUI.WindowTitle = "${minsRemaining}mins to go"
        write-host "chi: $minsRemaining"
    }    
    
    start-sleep -seconds 1; # check every second
}


# time has passed, so play the audio queue
$sound.SoundLocation = "c:\WINDOWS\Media\Windows Unlock.wav";
$sound.Play();

write-host "Finished."