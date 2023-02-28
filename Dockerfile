FROM mcr.microsoft.com/dotnet/sdk:7.0 AS dotnet-build
WORKDIR /src

RUN curl -sL https://deb.nodesource.com/setup_18.x |  bash -
RUN apt-get install -y nodejs

COPY . /src
RUN dotnet restore "workshop-react.csproj"
RUN dotnet build "workshop-react.csproj" -c Release -o /app/build

FROM dotnet-build AS dotnet-publish
RUN dotnet publish "workshop-react.csproj" -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:7.0 as final
WORKDIR /app
COPY --from=dotnet-publish /app/publish .

ENTRYPOINT [ "dotnet", "workshop-react.dll" ]