#! /bin/sh

PORT=8081

ifconfig wlan0 up

while true; do {
    SELECT=""
    LIST="$(iw dev wlan0 scan|grep SSID|sed 's/^.*: //')"
    for ITEM in $LIST; do
        SELECT="$SELECT\n<option vakue=\"$ITEM\">$ITEM</option>"
    done
    while true; do {
        echo -e 'HTTP/1.1 200 OK\r\n'
        cat << EOF
<html>
    <head>
        <title>Network Config</title>
    </head>
    <body>
         <form>
         <h3>System Setup</h3>
               WLAN: <select name="network">
               $SELECT
               </select><br>
               Passsphrase: <input type="text" name="Key">
         <h3>Browser Setup</h3>
               Server IP Address:<br>
               <input type="text" name="browserip"><br>
               <input type="submit" value="Submit">
         </form>
    </body>
</html>
EOF
    } | nc -l 127.0.0.1 $PORT | grep GET | sed 's/^GET \/?//;s/ HTTP.*$//'
    done
} 
done

