{
  lib,
  fetchFromGitHub,
  nix-update-script,
  python3Packages,
  versionCheckHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "basic-memory";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "basicmachines-co";
    repo = "basic-memory";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ClSY1QB11+KmohBZSrjA0IwuWmj813ayKY6zDOT4YNw=";
  };

  build-system = with python3Packages; [
    hatchling
    uv-dynamic-versioning
  ];

  dependencies = lib.flatten (
    with python3Packages;
    [
      sqlalchemy
      pyyaml
      typer
      aiosqlite
      greenlet
      pydantic
      pydantic.optional-dependencies.email
      mcp
      pydantic-settings
      loguru
      markdown-it-py
      python-frontmatter
      rich
      unidecode
      dateparser
      watchfiles
      fastapi
      fastapi.optional-dependencies.standard
      alembic
      pillow
      pybars3
      fastmcp
      pyjwt
      python-dotenv
      pytest-aio
      aiofiles
      asyncpg
      pytest-asyncio
      psycopg
      mdformat
      mdformat-gfm
      mdformat-frontmatter
      sniffio
      anyio
      httpx
      fastembed
      sqlite-vec
      openai
      logfire
      psutil
      uvloop
      filelock
      fastapi-redis-sdk
      pathspec
    ]
  );
  pythonRemoveDeps = [ "pyright" ];
  pythonRelaxDeps = [
    "fastapi-redis-sdk"
    "fastapi"
    "psycopg"
  ];

  nativeCheckInputs = [ versionCheckHook ];
  pythonImportsCheck = [
    "basic_memory"
    "basic_memory.api.app"
  ];

  makeWrapperArgs = [
    "--set"
    "PYTHONPATH"
    "${placeholder "out"}/${python3Packages.python.sitePackages}:${python3Packages.makePythonPath finalAttrs.passthru.dependencies}"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Local-first knowledge management combining Zettelkasten with knowledge graphs";
    homepage = "https://github.com/basicmachines-co/basic-memory";
    changelog = "https://github.com/basicmachines-co/basic-memory/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ wildsands ];
    platforms = lib.platforms.unix;
    mainProgram = "basic-memory";
  };
})
