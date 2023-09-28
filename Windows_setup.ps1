# Name is Important
write-host " #     # #     # #     #    #       ####### " -foregroundcolor "Red"
write-host " #     # #     #  #   #     #       #       " -foregroundcolor "Red"
write-host " #     # #     #   # #      #       #       " -foregroundcolor "White"
write-host " ####### #     #    #       #       #####   " -foregroundcolor "White"
write-host " #     # #     #    #       #       #       " -foregroundcolor "Green"
write-host " #     # #     #    #       #       #       " -foregroundcolor "Green"
write-host " #     #  #####     #       ####### ####### " -foregroundcolor "Yellow"
                                  

# Set Wget Progress to Silent, Becuase it slows down Downloading by +50x
echo "Setting Wget Progress to Silent, Becuase it slows down Downloading by +50x`n"
$ProgressPreference = 'SilentlyContinue'

#Initial varibles URL Download
$burp="https://drive.google.com/uc?id=1_KkjelkI8WoS0S6wBxfJHI3QszZTCLw8&authuser=0&export=download&confirm=t"
$jdk="https://drive.google.com/uc?id=1gYoD2X_ljWAp5TrT7fr3udcmFZtf8RTV&authuser=0&export=download&confirm=t"
$jruby="https://repo1.maven.org/maven2/org/jruby/jruby-complete/9.4.3.0/jruby-complete-9.4.3.0.jar"
$jython="https://repo1.maven.org/maven2/org/python/jython-standalone/2.7.3/jython-standalone-2.7.3.jar"

# Install JDK and JRE
echo "Downnloading Java JDK-20 ...."
Invoke-Webrequest -Uri $jdk -OutFile jdk-20.msi -verbose
echo "JDK-20 Downloaded, lets start the Installation process"
start -wait jdk-20.msi

# Downloading Burp Suite Professional
echo "`Downloading Burp Suite Professional v2022.8.2 ...."
Invoke-Webrequest -Uri $burp -OutFile Burp-Suite-Pro.jar -verbose

#Downloading Jython.jar and Jruby.jar for Environment
Invoke-Webrequest -Uri $jython -OutFile Jython.jar -verbose
Invoke-Webrequest -Uri $jruby -OutFile Jruby.jar -verbose

# Creating Burp.bat file with command for execution
$path = "java --add-opens=java.desktop/javax.swing=ALL-UNNAMED --add-opens=java.base/java.lang=ALL-UNNAMED -javaagent:`"$pwd\loader.jar`" -noverify -jar `"$pwd\Burp-Suite-Pro.jar`""
$path | add-content -path Burp.bat
echo "`nBurp.bat file is created"


# Creating Burp-Suite-Pro.vbs File for background execution
if (Test-Path Burp-Suite-Pro.vbs) {
   Remove-Item Burp-Suite-Pro.vbs}
echo "Set WshShell = CreateObject(`"WScript.Shell`")" > Burp-Suite-Pro.vbs
add-content Burp-Suite-Pro.vbs "WshShell.Run chr(34) & `"$pwd\Burp.bat`" & Chr(34), 0"
add-content Burp-Suite-Pro.vbs "Set WshShell = Nothing"
echo "`nBurp-Suite-Pro.vbs file is created."

# Lets Activate Burp Suite Professional with keygenerator and Keyloader
echo "Reloading Environment Variables ...."
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User") 
echo "`n`nStarting Keygenerator ...."
start-process java.exe -argumentlist "-jar keygen.jar"
echo "`n`nStarting Burp Suite Professional"
java --add-opens=java.desktop/javax.swing=ALL-UNNAMED --add-opens=java.base/java.lang=ALL-UNNAMED -javaagent:"loader.jar" -noverify -jar "Burp-Suite-Pro.jar"


# Lets Download the latest Burp Suite Professional jar File
echo "`n`t`t 1. Please download latest Burp Suite Professional Jar file from :-:"
echo "`n`t`t https://portswigger.net/burp/releases/startdownload?product=pro&version=&type=Jar"
echo "`n`t`t 2. Replace the existing Burp-Suite-Pro.jar file with downloaded jar file. `n`t Keep previous file name"
