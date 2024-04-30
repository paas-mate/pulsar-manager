FROM shoothzj/compile:jdk17-gradle-node AS compiler

RUN curl -sL https://deb.nodesource.com/setup_20.x -o /tmp/nodesource_setup.sh && \
    bash /tmp/nodesource_setup.sh && \
    rm -rf /tmp/nodesource_setup.sh && \
    apt-get update && \
    apt-get install -y --no-install-recommends nodejs

RUN git clone --depth 1 https://github.com/apache/pulsar-manager.git

WORKDIR /pulsar-manager

RUN gradle build -x test

RUN mkdir /opt/pulsarmanager

RUN tar -xf /pulsar-manager/build/distributions/pulsar-manager.tar -C /opt/pulsarmanager --strip-components 1

RUN rm -f /opt/pulsarmanager/bin/pulsar-manager.bat

FROM shoothzj/base:jdk17

WORKDIR /opt

COPY --from=compiler /opt/pulsarmanager /opt/pulsarmanager

ENV pulsarmanager_HOME /opt/pulsarmanager

COPY --chmod=0755 entrypoint.sh /opt/pulsarmanager/entrypoint.sh

WORKDIR /opt/pulsarmanager

CMD [ "/opt/pulsarmanager/bin/pulsar-manager" ]

ENTRYPOINT [ "/opt/pulsarmanager/entrypoint.sh" ]
