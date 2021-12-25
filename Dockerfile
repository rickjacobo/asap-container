FROM vmware/powerclicore:12.4.1
  
ENV ENV_VISERVER=127.0.0.1
ENV ENV_VISERVER_USER=administrator@vsphere.local
ENV ENV_VISERVER_PASSWORD=password

RUN mkdir /scripts
RUN mkdir -p /scripts/modules/name
COPY ./modules/name /scripts/modules/name 
WORKDIR /scripts
COPY ./scripts /scripts
RUN pwsh setup.ps1
