import { app, HttpRequest, HttpResponseInit } from "@azure/functions";

export async function health(_request: HttpRequest): Promise<HttpResponseInit> {
  const now = new Date().toISOString();
  return {
    status: 200,
    jsonBody: {
      status: "ok",
      service: "gpv2-estimator-api",
      timestamp: now
    }
  };
}

app.http("health", {
  methods: ["GET"],
  authLevel: "anonymous",
  route: "health",
  handler: health
});
