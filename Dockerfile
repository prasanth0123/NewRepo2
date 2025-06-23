FROM mcr.microsoft.com/dotnet/core/aspnet:3.1 AS base
WORKDIR /app
EXPOSE 5010

FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /src
COPY ["dockerdotnetapps.csproj", "./"]
RUN dotnet restore "./dockerdotnetapps.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "dockerdotnetapps.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "dockerdotnetapps.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "dockerdotnetapps.dll"]
