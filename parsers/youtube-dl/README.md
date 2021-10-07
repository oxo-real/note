# description

'clone_yt' downloads youtube videos and available metadata.


# requirements

The run properly, the script needs Bash and Python.

## linux
Linux users can download and run the script from a terminal window.

## windows
A windows user needs Windows10 and has to install 'Ubuntu 18.04 LTS' from the app store.

From the linux environment, the script can then be downloaded, installed and ran. 

Users can use the quick guide below or follow the more comprehensive instructions.

### quick guide
```
curl -L https://gitlab.com/praesidio/clone_yt/-/raw/master/make_clone_yt.sh -o install.sh && sh install.sh
sh clone_yt.sh -u https://www.youtube.com/watch?v=Ag1AKIl_2GM
```


# detailed instructions for preparation on a Windows10 (NL) host machine

## activate powershell and subsystem

Check 'Windows Powershell 2.0' and 'Windows-subsysteem voor Linux'

*'> Start > Configuratiescherm > Systeem en beveiliging > Programma's > Programma's en onderdelen > Windows-onderdelen in- of uitschakelen'*

## install linux Ubuntu app

Search and install 'Ubuntu 18.04 LTS'

*'> Start > Microsoft Store > Zoeken'*

## run linux Ubuntu app

Open 'Ubuntu 18.04 LTS'

*'> Start'*

## linux Ubuntu login

on initial login; create an username and password

## download installer

Execute the code snippet below from a linux command line. This downloads the installer.
```
curl -L https://gitlab.com/praesidio/clone_yt/-/raw/master/make_clone_yt.sh -o install.sh
```

## execution of the installer

After that go to the directory where the download is written to.

Usually this is the users' home directory.

Run the installation script by running:
```
sh install.sh
```
If any dialogs are popping up, just enter through them with default values.


# yt_clone usage 

The yt_clone command downloads all data from an youtube uri.

## uri

Specify a youtube location uri after the compulsory -u flag.

## write destination

### to host environment

The scripts' default is to send data to the windows host environment.

The default write location is: 'C:/Users/$user/clone_yt_data/',

where '$user' is the active Windows10 username.

### other location

With the optional -o flag you can specifically choose the write destination.

# examples

## download data

### from single video to host environment
```
sh clone_yt.sh -u https://www.youtube.com/watch?v=Ag1AKIl_2GM
```

### from playlist to host environment
```
sh clone_yt.sh -u https://www.youtube.com/playlist?list=PL4o29bINVT4EG_y-k5jGoOu3-Am8Nvi10
```

### to specific location
```
sh clone_yt.sh -u https://www.youtube.com/watch?v=tVl-QNkopoE -o /tmp
```