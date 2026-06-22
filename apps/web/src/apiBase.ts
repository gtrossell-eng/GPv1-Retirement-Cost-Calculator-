const configuredApiBase = import.meta.env.VITE_API_BASE_URL?.trim();

function normalizeApiBase(value: string): string {
  if (!value) return "/api";
  if (value === "/") return "";
  return value.endsWith("/") ? value.slice(0, -1) : value;
}

const apiBase = normalizeApiBase(configuredApiBase || "/api");

export function buildApiUrl(path: string): string {
  const normalizedPath = path.startsWith("/") ? path : `/${path}`;
  return `${apiBase}${normalizedPath}`;
}
