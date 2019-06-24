[![DockerHub Badge](http://dockeri.co/image/bradbeck/nexus-ha)](https://hub.docker.com/r/bradbeck/nexus-ha/)

A Dockerfile for Sonatype Nexus Repository Manager 3 ready for HA.

GitHub Repository: https://github.com/bradbeck/nexus-ha

To (re)build the image:

```
$ docker build --rm -t bradbeck/nexus-ha .
```

Initial Setup
-------------
The following only needs to be done once in order to setup the environment, i.e. create the docker volume to hold the NXRM3 license.

Create a custom docker network:
```
docker network create custom
```

Create a docker volume to store the NXRM3 license
```
docker volume create java-prefs
```

Create or recreate the docker volume used for blob storage:
```
docker volume create shared-blobs
```

Start an instance NXRM3 and upload the license
```
docker run --rm -p 8081:8081 -v java-prefs:/opt/sonatype/sonatype-work/nexus3/javaprefs --network custom -it bradbeck/nexus-ha
```
Wait for the following banner (NXRM-STARTED) in the console output before continuing to the next step:
```
-------------------------------------------------

Started Sonatype Nexus PRO 3.7.0-04

-------------------------------------------------
```
Follow the steps in ["Uploading a License"](https://help.sonatype.com/display/NXRM3M/Configuration#Configuration-UploadingaLicense ) for uploading the license. This will remain in the `java-prefs` docker volume for all of the remaining steps.

Once the license is uploaded, use `Ctl-C` to stop the NXRM3 container.

Cluster Startup
---------------
Start NXRM3 `nexusa` node, and wait for NXRM-STARTED:
```
docker run --rm -p 8081:8081 -v shared-blobs:/opt/sonatype/sonatype-work/nexus3/blobs -v java-prefs:/opt/sonatype/sonatype-work/nexus3/javaprefs --network custom --name nexusa -h nexusa -it bradbeck/nexus-ha
```

Start NXRM3 `nexusb` node, and wait for NXRM-STARTED:
```
docker run --rm -p 8082:8081 -v shared-blobs:/opt/sonatype/sonatype-work/nexus3/blobs -v java-prefs:/opt/sonatype/sonatype-work/nexus3/javaprefs --network custom --name nexusb -h nexusb -it bradbeck/nexus-ha
```

Start NXRM3 `nexusc` node, and wait for NXRM-STARTED:
```
docker run --rm -p 8083:8081 -v shared-blobs:/opt/sonatype/sonatype-work/nexus3/blobs -v java-prefs:/opt/sonatype/sonatype-work/nexus3/javaprefs --network custom --name nexusc -h nexusc -it bradbeck/nexus-ha
```
