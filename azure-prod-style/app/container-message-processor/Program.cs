using System.Text.Json;
using Azure;
using Azure.Identity;
using Azure.Storage.Blobs;

var builder = WebApplication.CreateBuilder(args);

// Ensure the app listens on 8080 when no platform URL is injected.
if (string.IsNullOrWhiteSpace(Environment.GetEnvironmentVariable("ASPNETCORE_URLS")))
{
    builder.WebHost.UseUrls("http://0.0.0.0:8080");
}

var storageAccountName = builder.Configuration["STORAGE_ACCOUNT_NAME"];
var storageContainerName = builder.Configuration["STORAGE_CONTAINER_NAME"] ?? "processed-messages";

builder.Services.AddSingleton(new DefaultAzureCredential());
builder.Services.AddSingleton(sp =>
{
    if (string.IsNullOrWhiteSpace(storageAccountName))
    {
        throw new InvalidOperationException("STORAGE_ACCOUNT_NAME is not configured.");
    }

    var credential = sp.GetRequiredService<DefaultAzureCredential>();
    var serviceUri = new Uri($"https://{storageAccountName}.blob.core.windows.net");
    return new BlobServiceClient(serviceUri, credential);
});

var app = builder.Build();

app.MapGet("/", () => Results.Ok(new
{
    service = "container-message-processor",
    endpoints = new[] { "/health", "/process" }
}));

app.MapGet("/health", () => Results.Ok(new { status = "ok", service = "container-message-processor" }));

app.MapPost("/process", async (
    JsonElement payload,
    BlobServiceClient blobServiceClient,
    ILoggerFactory loggerFactory,
    CancellationToken cancellationToken) =>
{
    var logger = loggerFactory.CreateLogger("Processor");

    if (payload.ValueKind is JsonValueKind.Undefined or JsonValueKind.Null)
    {
        return Results.BadRequest(new { error = "Request body must be valid JSON." });
    }

    try
    {
        var containerClient = blobServiceClient.GetBlobContainerClient(storageContainerName);
        await containerClient.CreateIfNotExistsAsync(cancellationToken: cancellationToken);

        var proof = new
        {
            processedAtUtc = DateTime.UtcNow,
            processedBy = "container-app-v1",
            status = "processed",
            payload
        };

        var blobName = $"processed/{DateTime.UtcNow:yyyyMMdd}/{Guid.NewGuid():N}.json";
        var blobClient = containerClient.GetBlobClient(blobName);
        await blobClient.UploadAsync(BinaryData.FromObjectAsJson(proof), overwrite: true, cancellationToken: cancellationToken);

        logger.LogInformation("Saved processed message to blob {BlobName}", blobName);

        return Results.Ok(new
        {
            message = "Processed by container app",
            blob = blobName,
            container = storageContainerName
        });
    }
    catch (RequestFailedException ex)
    {
        logger.LogError(ex, "Storage operation failed.");
        return Results.Problem(title: "Storage operation failed", detail: ex.Message, statusCode: 500);
    }
    catch (Exception ex)
    {
        logger.LogError(ex, "Unhandled processing error.");
        return Results.Problem(title: "Unhandled processing error", detail: ex.Message, statusCode: 500);
    }
});

app.Run();
