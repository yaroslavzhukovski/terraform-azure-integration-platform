using System.Net.Http.Json;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;

namespace ServiceBusToContainer.Functions;

public class ProcessOrder
{
    private readonly IHttpClientFactory _httpClientFactory;
    private readonly IConfiguration _config;
    private readonly ILogger<ProcessOrder> _logger;

    public ProcessOrder(IHttpClientFactory httpClientFactory, IConfiguration config, ILogger<ProcessOrder> logger)
    {
        _httpClientFactory = httpClientFactory;
        _config = config;
        _logger = logger;
    }

    [Function("ProcessOrder")]
    public async Task Run(
        [ServiceBusTrigger("orders", Connection = "AzureWebJobsServiceBus")] string message)
    {
        var baseUrl = _config["ContainerApp__BaseUrl"];
        if (string.IsNullOrWhiteSpace(baseUrl))
        {
            _logger.LogError("ContainerApp__BaseUrl is not configured.");
            return;
        }

        var client = _httpClientFactory.CreateClient();
        client.BaseAddress = new Uri(baseUrl);

        var payload = new
        {
            receivedAtUtc = DateTime.UtcNow,
            body = message
        };

        try
        {
            using var response = await client.PostAsJsonAsync("/process", payload);
            response.EnsureSuccessStatusCode();
            _logger.LogInformation("Forwarded message to container app. Status: {StatusCode}", response.StatusCode);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Failed to forward message to container app.");
        }
    }
}
