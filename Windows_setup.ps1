# Name is Important
echo "
                #####    #     #    #####    #     #   #     # 
               #     #   ##    #   #     #   #     #   ##    # 
               #         # #   #   #         #     #   # #   # 
                #####    #  #  #   #  ####   #  #  #   #  #  # 
                     #   #   # #   #     #   #  #  #   #   # # 
               #     #   #    ##   #     #   #  #  #   #    ## 
                #####    #     #    #####     ## ##    #     # 
"

# Set Wget Progress to Silent, Becuase it slows down Downloading by +50x
echo "Setting Wget Progress to Silent, Becuase it slows down Downloading by +50x`n"
$ProgressPreference = 'SilentlyContinue'

# Install JDK and JRE
echo "Downnloading Java JDK-20 ...."
Invoke-Webrequest "https://drive.google.com/file/d/1gYoD2X_ljWAp5TrT7fr3udcmFZtf8RTV/view?usp=sharing" -OutFile jdk-20.msi    
echo "JDK-20 Downloaded, lets start the Installation process"
start -wait jdk-20.msi
rm jdk-20.msi

#Downloading Configure BAPP
echo "Downloading Configure BAPP"
Invoke-Webrequest "https://drive.google.com/file/d/1IDVWmtwARSNimAVSOQ-242-BPea5bmrM/view?usp=sharing" -OutFile "Conf.json"
# Downloading Burp Suite Professional
echo "`Downloading Burp Suite Professional v2022.8.2 ...."
Invoke-Webrequest "https://drive.google.com/file/d/1_KkjelkI8WoS0S6wBxfJHI3QszZTCLw8/view?usp=sharing" -OutFile "Burp-Suite-Pro.jar"

#Downloading Jython.jar and Jruby.jar for Environment
Invoke-Webrequest -Uri https://drive.google.com/file/d/1yZX0bg5wyINRz9tgpnBQENnI4O1MdDk3/view?usp=sharing -OutFile "Jython.jar" -verbose
Invoke-Webrequest -Uri https://drive.google.com/file/d/1ZwslHX99GNM4FglogpbYlEnE2pejHfdo/view?usp=sharing -OutFile "Jruby.jar" -verbose

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
