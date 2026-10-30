{
  buildPythonPackage,
  fetchFromGitHub,
  lib,

  anyio,
  fakeredis,
  fastapi,
  httpx,
  opentelemetry-api,
  opentelemetry-sdk,
  pydantic,
  pydantic-settings,
  pytest-asyncio,
  pytest-mock,
  pytest-timeout,
  pytestCheckHook,
  redis,
  uv-build,
}:

buildPythonPackage (finalAttrs: {
  pname = "fastapi-redis-sdk";
  version = "0.9.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "redis";
    repo = "fastapi-redis-sdk";
    tag = finalAttrs.version;
    hash = "sha256-zv08p2rTNgs5EXX1MnibAnXnfaT66YTQ/G1Hy+CuetM=";
  };

  build-system = [ uv-build ];

  dependencies = [
    anyio
    fastapi
    pydantic
    pydantic-settings
    redis
  ];

  pythonImportsCheck = [ "redis_fastapi" ];
  nativeCheckInputs = lib.flatten [
    anyio
    anyio.optional-dependencies.trio
    fakeredis
    fakeredis.optional-dependencies.lua
    httpx
    opentelemetry-api
    opentelemetry-sdk
    pytest-asyncio
    pytest-mock
    pytest-timeout
    pytestCheckHook
  ];
  pytestFlags = [
    "-o"
    "addopts="
  ];

  meta = {
    description = "FastAPI SDK for Redis";
    homepage = "https://github.com/redis/fastapi-redis-sdk";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ wildsands ];
  };
})
