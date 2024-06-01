# Use the official ASP.NET Core runtime as a parent image
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 8080

# Use the SDK image to build the application
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["fifa.csproj", "./"]
RUN dotnet restore "./fifa.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "fifa.csproj" -c Release -o /app/build

# Publish the application
FROM build AS publish
RUN dotnet publish "fifa.csproj" -c Release -o /app/publish

# Use the runtime image to run the application
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "fifa.dll"]
