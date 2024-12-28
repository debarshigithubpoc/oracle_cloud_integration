## Build the image
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /dotnethellloworld
COPY . .
RUN dotnet restore
RUN dotnet publish -c release -o /app --no-restore

## Run the image 
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build /app ./
ENTRYPOINT [ "dotnet","dotnethelloworld.dll" ]