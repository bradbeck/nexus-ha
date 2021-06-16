# syntax=docker/dockerfile:1
FROM scratch AS base
COPY --from=sonatype/nexus3:latest / /
ENV SONATYPE_DIR=/opt/sonatype
ENV NEXUS_HOME=${SONATYPE_DIR}/nexus
ENV NEXUS_DATA=/nexus-data
RUN mkdir ${NEXUS_DATA}/blobs
RUN mkdir ${NEXUS_DATA}/javaprefs
RUN chown -R nexus:nexus ${NEXUS_DATA}
RUN echo "nexus.clustered=true" >> ${NEXUS_HOME}/etc/nexus-default.properties
RUN echo "nexus.blobstore.provisionDefaults=true" >> ${NEXUS_HOME}/etc/nexus-default.properties
RUN echo "nexus.skipDefaultRepositories=false" >> ${NEXUS_HOME}/etc/nexus-default.properties
RUN echo "nexus.hazelcast.discovery.isEnabled=true" >> ${NEXUS_HOME}/etc/nexus-default.properties

FROM scratch
LABEL name="Nexus Repository Manager (HA)" \
      maintainer="Brad Beck <bradley.beck+docker@gmail.com>"
ENV SONATYPE_DIR=/opt/sonatype
ENV NEXUS_HOME=${SONATYPE_DIR}/nexus
ENV NEXUS_DATA=/nexus-data
ENV NEXUS_CONTEXT=''
ENV SONATYPE_WORK=${SONATYPE_DIR}/sonatype-work
ENV INSTALL4J_ADD_VM_PARAMS="-Xms2703m -Xmx2703m -XX:MaxDirectMemorySize=2703m -Djava.util.prefs.userRoot=${NEXUS_DATA}/javaprefs"

COPY --from=base / /
EXPOSE 8081
USER nexus

CMD ["sh", "-c", "${SONATYPE_DIR}/start-nexus-repository-manager.sh"]
