# SteamCMD
[![](https://images.microbadger.com/badges/image/sigboe/steamcmd.svg)](http://microbadger.com/images/sigboe/steamcmd "Get your own image badge on microbadger.com") [![](https://images.microbadger.com/badges/version/sigboe/steamcmd.svg)](http://microbadger.com/images/sigboe/steamcmd "Get your own version badge on microbadger.com")

This Dockerfile will build an image for SteamCMD containerized. It follows best practice from Valve. Full documentation of how to use the program can be found [here](https://developer.valvesoftware.com/wiki/SteamCMD).

## Instancing the container
    docker run \
        -it
        --name steamcmd \
        -e PUID=<UID> -e PGID=<GID> \
        -v </path/to/steamapps>:/steamapps \
        sigboe/steamcmd

### Parameters

* `-i` Interactive mode for terminal, `-t` I think this one mainly makes things look proper.
* `--name steamcmd` -This is a useful name, you may pick another. If you don't pick a name a random name will be generated. 
* `-e PGID` for for GroupID - see below for explanation
* `-e PUID` for for UserID - see below for explanation
* `-v /steamapps` -You want to mount the installation directory of your games you can use, example using another docker container running wine, or something else.


### User / Group identifiers

Inside the docker container best practice from Valve is to run the executable as a user called steam. While we want to write outside the container using the `-v` flags, so we can make use of the installed games. We avoid making permission problems by defining the PUID and PGID using the `-e` flags. 

In my instance my `PUID=1000` and `PGID=1000` you can find yours by using the `id` command.

    id


## Usage **IMPORTANT**

After the docker container is created you can start it using the command

    docker start -ai steamcmd

To download most game servers, you can login anonymously. After you started the container

    login anonymous

Or you may have to log in with your username, substitute anonymous with your user name, you will be prompted to enter your password and if applicable two factor authentication key. **IMPORTANT** the password will be visible on screen while typing. This is sadly just how SteamCMD was made. Subsequent logins when you start the container will not require two factor authentication, but it is required if you create a new container from the image.

### **IMPORTANT** game/server install directory

Every time you download a game you have to set install directory. This again is sadly how SteamCMD is made, if they improve this I will update the instructions. This is how you do it:

    force_install_dir /steamapps/<NameOfTheGame>

This will make a folder inside the directory which is mounted externally (if you followed the instructions above) for every game. You can then run them in another Docker container or in wine or how you like. It is not good practice to run it inside the same Docker container as SteamCMD because then you would have to save your password in plain text and turn off two factor authentication.

### Game/server installation

Please see the official instructions here.

https://developer.valvesoftware.com/wiki/SteamCMD#Downloading_an_app

## Build from Dockerfile

You don't need to build the Dockerfile. If you follow the instructions above, it will download it from the repository, if you want to build from Dockerfile you can follow the basic instructions below.

First you of all you need to have Docker installed. [Assuming linux see here](https://docs.docker.com/engine/installation/linux/). 

    docker build -t steamcmd https://github.com/sigboe/SteamCMD

You either need to run the `docker` command as root, or need to be in the docker group.
