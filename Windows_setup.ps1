echo $(Set-ExecutionPolicy Unrestricted -verbose)
$URL="https://github.com/lehieuhuy/Burp-Suite/archive/refs/heads/main.zip"
echo $(Invoke-Webrequest -Uri $URL -OutFile "Burp-main.zip")
echo $(Expand-Archive -LiteralPath 'Burp-main.zip' -DestinationPath 'Burp')
echo $(cd Burp)
echo $(cd Burp-Suite-main)

# Check JDK-17 Availability or Download JDK-20
$jdk17 = Get-WmiObject -Class Win32_Product -filter "Vendor='Oracle Corporation'" |where Caption -clike "Java(TM) SE Development Kit 20*"
if (!($jdk17)){
    echo "`t`tDownnloading Java JDK-20 ...."
    wget "https://download.oracle.com/java/20/latest/jdk-20_windows-x64_bin.msi" -O jdk-20.msi    
    echo "`n`t`tJDK-20 Downloaded, lets start the Installation process"
    start -wait jdk-20.msi
    rm jdk-20.msi
}else{
    echo "Required JDK-20 is Installed"
    $jdk17
}
# Downloading Burp Suite Professional
if (Test-Path Burp-Suite-Pro.jar){
    echo "Burp Suite Professional JAR file is available.`nChecking its Integrity ...."
    if (((Get-Item Burp-Suite-Pro.jar).length/1MB) -lt 500 ){
        echo "`n`t`tFiles Seems to be corrupted `n`t`tDownloading Burp Suite Professional v2022.8.2 ...."
        wget "https://portswigger.net/burp/releases/startdownload?product=pro&version=2022.8.2&type=Jar" -O "Burp-Suite-Pro.jar"
        echo "`nBurp Suite Professional is Downloaded.`n"
    }else {echo "File Looks fine. Lets proceed for Execution"}
}else {
    echo "`n`t`tDownloading Burp Suite Professional v2022.8.2 ...."
    wget "https://portswigger-cdn.net/burp/releases/download?product=pro&version=2022.8.2&type=jar" -O "Burp-Suite-Pro.jar"
    echo "`nBurp Suite Professional is Downloaded.`n"
}

# Creating Burp.bat file with command for execution
if (Test-Path burp.bat) {rm burp.bat} 
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

# Remove Additional files
rm Linux_Setup.sh
del -Recurse -Force .\.github\


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
