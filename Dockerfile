FROM shoothzj/compile:jdk21-gradle AS compiler

RUN git clone --depth 1 https://github.com/apache/pulsar-manager.git && \
    cd pulsar-manager && \
    gradle build -x test && \
    mkdir /opt/pulsarmanager && \
    tar -xf /pulsarmanager/target/pulsarmanager.tar.gz -C /opt/pulsarmanager --strip-components 1

FROM shoothzj/base:jdk21

WORKDIR /opt

COPY --from=compiler /opt/pulsarmanager /opt/pulsarmanager

ENV pulsarmanager_HOME /opt/pulsarmanager

COPY --chmod=0755 entrypoint.sh /opt/pulsarmanager/entrypoint.sh

WORKDIR /opt/pulsarmanager

ENTRYPOINT [ "/opt/pulsarmanager/entrypoint.sh" ]
