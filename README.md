# guacamole-docker

This is a basic Docker Compose-based configuration of Apache Guacamole that you can use to quickly get Guacamole Client and Server up and running on your system wihout any extra PITA.

You can prefer it because of:
- Simplicity of setup and management
- Clean and simple internal structure
- Ability to build Guacamole from sources with simple steps
- Usage of small footprint alpine images when applicable
- Possibility to use my forks of Guacamole 1.1.0 Client and Server with some fixes and improvements, f.e. an improved complete quality Russian translation, reworked Russian/Latin OSK, improved RDP Russian/Latin input experience with specially added keymap, etc.
- Simple management of Guacamole database with web GUI

This configuration was tested and working in an production environment!

### A guide to bring it up:

As a prerequisites, you need to make a copy of this repo files somewhere in your system in convenient place. Also you need a working docker and docker-compose of course.

1. Git Clone a Guacamole Client in your *client/guacamole-client-1.1.0* subdirectory of this repo copy. For example, you can clone my Guacamole Client fork issuing `git clone --branch ds-docker --depth 1 "https://github.com/darksimpson/guacamole-client" "./guacamole-client-1.1.0"` in terminal inside *client* subdirectory.

2. Build Guacamole Client issuing `./build.sh` inside *client* subdirectory. After successful build you will get two resulting files copied into *client* subdirectory: *guacamole-1.1.0.war* and *guacamole-auth-jdbc-mysql-1.1.0.jar*.
**Note**: if you need some additional extensions in your guacamole setup, add extra copy commands with needed JAR artifacts in *build.sh* before running it. F.e. if you will need TOTP extension, add `cp ${BASEDIR}/guacamole-client-1.1.0/extensions/guacamole-auth-totp/target/guacamole-auth-totp-1.1.0.jar ${BASEDIR}/guacamole-auth-totp-1.1.0.jar` to the end of *build.sh* after other copy commands.

3. Download *mysql-connector-java* JAR artifact and place it also in *client* subdirectory. I recommend getting *mysql-connector-java-8.0.19.jar* as it was tested by me and you will not need to edit any related entries in *docker-compose.yml*.
**Note**: at the moment of writing this guide you can download connector from https://downloads.mysql.com/archives/get/p/3/file/mysql-connector-java-8.0.19.zip. You will need to extract needed JAR artifact from this zip.

4. Git Clone a Guacamole Server in your *server/guacamole-server-1.1.0* subdirectory. You can also clone my Guacamole Server fork (at least to be in sync with Client) issuing `git clone --branch ds-docker --depth 1 "https://github.com/darksimpson/guacamole-server" "./guacamole-server-1.1.0"` inside *server* subdirectory.
**Note**: you can skip this (fetch) and next (build) steps and simply let Docker to fetch my Server fork prebuilt image from docker.io repo, but I personally do not recommend this way because I can not guarrantee that my image from docker.io repo will be the latest one. Also, the image in docker.io repo is built for Linux/AMD64 only (at the momet of writing this guide).

5. Build Guacamole Server issuing `./build.sh` inside *server* subdirectory. After successful build you will get new image tagged *darksimpson/guacd:1.1.0* in your local docker image repository.

6. Edit your docker-compose.yaml file in the root directory of this repo copy for your own setup:
	- Edit "image: darksimpson/guacd:1.1.0" line if you want to use other Server image (i.e. original one from Apache).

	- Uncomment "environment:" and "- GUACD_LOG_LEVEL=debug" by deleting # prepending symbols if you want to get debug output in Server container's log.

	- If you will want to use convenient temporary RAM disk for Guacamole great file exchange capabilities, edit "/guacdisk1" volume properties, f.e. "size: 104857600" to you preference. You will then need to additionally setup this storage (/guacdisk1) in Guacamole admin interface (read Guacamole docs to get more info about this https://guacamole.apache.org/doc/1.1.0/gug/). Or you can comment (with prepending # symbol) the whole "volumes:" section if you do not need this functionality at all (this will free some RAM allocated by container also). You can even retarget this (or another) volume to the real storage device if you want. You can read and learn more about this in Docker and Docker Compose docs (https://docs.docker.com/compose/).

	- Edit "- MYSQL_ROOT_PASSWORD=ROOTPASSWORD" line in "mysql:" "environment:" section and change ROOTPASSWORD to some real password.

	- Edit "- MYSQL_PASSWORD=GUACPASSWORD" line in "mysql:" and "guacamole:" "environment:" sections and change GUACPASSWORD to some other real password also (it must be same in both "mysql:" and "guacamole:" sections!).

	- If you copied some additional JARs in step 2, add corresponding lines in "guacamole:" "volumes:" section after "- ./client/guacamole-auth-jdbc-mysql-1.1.0.jar:/guacamole/extensions/guacamole-auth-jdbc-mysql-1.1.0.jar:ro" line. You can simply copy this line and only change JAR filenames to needed ones.
**Note**: for some extensions you will also need to edit *guacamole.properties* file in root directory of your copy of this repo. Please consult Guacamole docs about this.

	- Change "- 3010:8080" line in "guacamole:" "ports:" section if you want to use HTTP port other than 3010 to access your Guacamole Client.
**Note**: If you want to setup HTTPS access or other complex configuration you will need to use some HTTP reverse proxy. You can read a bit more about this in Guacamole docs (https://guacamole.apache.org/doc/1.1.0/gug/proxying-guacamole.html).
Note that in the docs, Guacamole app is accessed with "http://host:port/guacamole/" and this setup will deploy Guacamole app in web-root, so it must be accessed with "http://host:port/". This was made for simplicity of access and configuration.
If you setup Guacamole in some environment like Synology DSM, you can use your DSM's GUI control panel to conveniently setup reverse proxy and HTTPS access in most cases. If not, you can even add reverse proxy container section in this docker-compose.yml (if you will use proxy only for accessing Guacamole) and setup it for your preferences and convenience. Please lurk deeply about this topic in internets if you want.

	- You can uncomment "adminer:" section if you want to look inside your Guacamole database or make backups/restores/edits with simplicity of Adminer web GUI. You will also need to edit "- 3011:8080" in "ports:" section of "adminer:" if you want to change Adminer's HTTP GUI port. If you enable Adminer you will be able to access database with host: mysql, port: 3306, database: guacamole, user: guacamole and your "MYSQL_PASSWORD".

7.  Apply a workaround fix for MySQL security-related things about configuration files by issuing `chmod 664 guacamole-my-lowmem.cnf` in your copy of this repo directory (i.e. where resides your guacamole-my-lowmem.cnf file)

**That's all! If it was done right you will now have a working Guacamole setup. Regards!**

To **run** your Guacamole setup you need to issue `docker-compose up -d` in your copy of this repo directory.

To **stop and unsetup** your Guacamole for some reason you need to issue `docker-compose down` in your copy of this repo directory. This will completely unsetup and remove all things related to your Guacamole (excluding images). Do not fear doing this. Your user data will not be deleted because DB files resides in *mysql_data* subdirectory and they will not be touched.

To **update** containers' images (f.e. if you want to move on newer software versions) you will need to firstly do **unsetup**, then issue `docker-compose pull` and then rerun it with `docker-compose up -d` again. But I personally do not recommend to move to newer versions "just because you want", especially if your setup is running good, as it can theoretically break someting. Do it only if you really need. F.e. if you want to apply some security fixes that was integrated in newer versions of software.

P.S. If you are not a Docker-pro or a new to Docker technology at all, I recommend also to deploy a really great [Portainer project](https://www.portainer.io/ "Portainer project") (also using convenient docker-compose, side-by-side with your Guacamole and/or other Docker setups, why not). It will greatly enhance your Docker management experience and simplify many tasks with it's great GUI!

**Cheers!**