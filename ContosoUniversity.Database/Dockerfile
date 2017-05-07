# escape=`
FROM microsoft/mssql-server-windows-developer

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop';"]

EXPOSE 1433
VOLUME c:\database
ENV sa_password VeryStrOngPassword!
ENV ACCEPT_EULA=Y