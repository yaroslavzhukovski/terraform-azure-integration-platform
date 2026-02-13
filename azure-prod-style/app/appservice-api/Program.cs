using Azure.Identity;
using Azure.Messaging.ServiceBus;
using Azure.Messaging.ServiceBus.Administration;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

builder.Services.AddSingleton<DefaultAzureCredential>();

builder.Services.AddSingleton<ServiceBusClient>(sp =>
{
    var config = sp.GetRequiredService<IConfiguration>();

    var namespaceFqdn = config["SERVICEBUS_FQDN"] ?? config["SERVICEBUS_NAMESPACE"];
    if (string.IsNullOrWhiteSpace(namespaceFqdn))
    {
        throw new InvalidOperationException("SERVICEBUS_FQDN (or SERVICEBUS_NAMESPACE) is required (e.g. sb-xxx.servicebus.windows.net).");
    }

    var connectionString = config["SERVICEBUS_CONNECTION_STRING"];
    if (!string.IsNullOrWhiteSpace(connectionString))
    {
        return new ServiceBusClient(connectionString);
    }

    var credential = sp.GetRequiredService<DefaultAzureCredential>();
    return new ServiceBusClient(namespaceFqdn, credential);
});

builder.Services.AddSingleton<ServiceBusAdministrationClient>(sp =>
{
    var config = sp.GetRequiredService<IConfiguration>();

    var namespaceFqdn = config["SERVICEBUS_FQDN"] ?? config["SERVICEBUS_NAMESPACE"];
    if (string.IsNullOrWhiteSpace(namespaceFqdn))
    {
        throw new InvalidOperationException("SERVICEBUS_FQDN (or SERVICEBUS_NAMESPACE) is required (e.g. sb-xxx.servicebus.windows.net).");
    }

    var connectionString = config["SERVICEBUS_CONNECTION_STRING"];
    if (!string.IsNullOrWhiteSpace(connectionString))
    {
        return new ServiceBusAdministrationClient(connectionString);
    }

    var credential = sp.GetRequiredService<DefaultAzureCredential>();
    return new ServiceBusAdministrationClient(namespaceFqdn, credential);
});

var app = builder.Build();

app.UseSwagger();
app.UseSwaggerUI();

app.MapGet("/", () => Results.Text("OK"));

app.MapGet("/test", () =>
{
    const string html = """
    <!doctype html>
    <html lang="en">
    <head>
      <meta charset="utf-8" />
      <meta name="viewport" content="width=device-width, initial-scale=1" />
      <title>Service Bus Enqueue Test</title>
      <style>
        body { font-family: system-ui, -apple-system, Segoe UI, Roboto, sans-serif; margin: 24px; }
        label { display: block; margin-bottom: 8px; font-weight: 600; }
        textarea { width: 100%; max-width: 640px; height: 120px; }
        button { margin-top: 12px; padding: 8px 14px; }
        pre { background: #f5f5f5; padding: 12px; max-width: 640px; }
      </style>
    </head>
    <body>
      <h1>Service Bus Enqueue Test</h1>
      <p>Send a message to <code>/enqueue</code>.</p>
      <label for="msg">Message</label>
      <textarea id="msg">Hello from /test</textarea><br/>
      <button onclick="send()">Send</button>
      <pre id="out">Ready.</pre>
      <script>
        async function send() {
          const message = document.getElementById('msg').value;
          const res = await fetch('/enqueue', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ message })
          });
          const text = await res.text();
          document.getElementById('out').textContent = text;
        }
      </script>
    </body>
    </html>
    """;

    return Results.Content(html, "text/html");
});

app.MapGet("/health", async (ServiceBusAdministrationClient admin, IConfiguration config, ILogger<Program> logger) =>
{
    var queueName = config["SERVICEBUS_QUEUE_NAME"] ?? "orders";
    if (string.IsNullOrWhiteSpace(queueName))
    {
        return Results.Problem("SERVICEBUS_QUEUE_NAME is required.");
    }

    try
    {
        var props = await admin.GetQueueRuntimePropertiesAsync(queueName);
        return Results.Ok(new
        {
            status = "ok",
            queue = queueName,
            activeMessageCount = props.Value.ActiveMessageCount
        });
    }
    catch (Exception ex)
    {
        logger.LogError(ex, "Health check failed for Service Bus queue {QueueName}", queueName);
        return Results.Problem(title: "Service Bus health check failed.", detail: ex.Message);
    }
});

app.MapPost("/enqueue", async (EnqueueRequest req, ServiceBusClient client, IConfiguration config, ILogger<Program> logger) =>
{
    if (string.IsNullOrWhiteSpace(req.Message))
    {
        return Results.BadRequest(new { error = "message is required" });
    }

    var queueName = config["SERVICEBUS_QUEUE_NAME"] ?? "orders";
    if (string.IsNullOrWhiteSpace(queueName))
    {
        return Results.Problem("SERVICEBUS_QUEUE_NAME is required.");
    }

    try
    {
        await using var sender = client.CreateSender(queueName);

        var msg = new ServiceBusMessage(req.Message)
        {
            MessageId = Guid.NewGuid().ToString("N"),
            PartitionKey = string.IsNullOrWhiteSpace(req.OrderId) ? "orders" : req.OrderId,
            ContentType = "text/plain"
        };

        await sender.SendMessageAsync(msg);
        logger.LogInformation("Sent message to queue {QueueName}", queueName);

        return Results.Ok(new { status = "sent", queue = queueName });
    }
    catch (Exception ex)
    {
        logger.LogError(ex, "Failed to send message to queue {QueueName}", queueName);
        return Results.Problem("Failed to send message to Service Bus.");
    }
});

app.Run();

record EnqueueRequest(string Message, string? OrderId);
