FROM       bradbeck/nexus3
MAINTAINER Brad Beck <bradley.beck+docker@gmail.com>

USER root

# configure nexus
RUN mkdir ${NEXUS_DATA}/blobs \
  && mkdir ${NEXUS_DATA}/javaprefs \
  && chown -R nexus:nexus ${NEXUS_DATA} \
  && echo "nexus.clustered = true" >> ${NEXUS_HOME}/etc/nexus-default.properties \
  && echo "nexus.blobstore.provisionDefaults = true" >> ${NEXUS_HOME}/etc/nexus-default.properties \
  && echo "nexus.skipDefaultRepositories = false" >> ${NEXUS_HOME}/etc/nexus-default.properties \
  && echo "nexus.hazelcast.discovery.isEnabled = true" >> ${NEXUS_HOME}/etc/nexus-default.properties

USER nexus
