# tested only on win 10 with ConEmu.

if ($args.length -eq 0) {
    write-host "You need to pass a parameter." -ForegroundColor Red;
    write-host "E.g.: .\script.ps1 10+.5"  -ForegroundColor Red;
    write-host "E.g.: .\script.ps1 10*3 (mins on left, mult on right. + doesnt work here)"  -ForegroundColor Red;
    exit;
}

$sound = new-Object System.Media.SoundPlayer;
$sound.SoundLocation = "c:\WINDOWS\Media\Windows Pop-up Blocked.wav";
$sound.Play();

write-host "Heard something? If not. check volume. (ctrl+c to cancel)"  -ForegroundColor Yellow;

###############################################################################
#clear-host

$firstArg = $args[0].ToString();

if ($firstArg -match "\*"){ ## if it has multiplication, it won't have sum.
    $arr = $firstArg.split("*");
    $m = $arr[0];
    $howManyTimes =$arr[1];
    $alarms = 1..$howManyTimes | ForEach-Object {
        $m.trim() / 1; # dividing string by 1 converts to float/int # XXX dupe code
    }
} else {
    $alarms = $firstArg.split("+") | ForEach-Object { 
        $_.trim() / 1; # dividing string by 1 converts to float/int
    };     
}
    
$alarmCount = $alarms.length
for ($idx = 0; $idx -lt $alarmCount; $idx++) {
    $idxDescription = $idx + 1;
    $mins = $alarms[$idx];
    $now = get-date;    
    $alarmTime = (get-date).AddMinutes($mins);
    
    while ($now -lt $alarmTime) {    
        $now = get-date;
        $newMinsRemaining = [Math]::ceiling(($alarmTime - $now).TotalMinutes);
        if ($minsRemaining -ne $newMinsRemaining) {
            $minsRemaining = $newMinsRemaining
            $msgTimeRemaining = "${minsRemaining}mins to go ";
            $msgAlarms = "(${idxDescription}/${alarmCount})";
            $host.ui.RawUI.WindowTitle = $msgTimeRemaining + $msgAlarms;
            write-host $msgTimeRemaining -NoNewline -ForegroundColor Green
            write-host $msgAlarms 
        }    
        
        start-sleep -seconds 1; # check every second
    }

    # time has passed, so play the audio cue
    $sound.SoundLocation = "c:\WINDOWS\Media\Windows Unlock.wav";
    $sound.Play();
    write-host "Alarm $idxDescription done";
}

$noAlarmsMsg = "No more alarms.";
$host.ui.RawUI.WindowTitle = $noAlarmsMsg;
write-host $noAlarmsMsg