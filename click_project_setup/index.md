# How to Create a Python CLI Package In 2022


As a DevOps Engineer, I like being able to create quick and simple CLI's to automate toil.

After lots of playing around with python dependency management, cli library's I think I have found a nice combination.
This is the stack:

- `click` The cli library
- `poetry` The dependency management
- `pytest` who does not love writing tests
- `precommit` - Sane checking before we commit

## Poetry

I have used lots of dependency managers in my time, and I have recently started to use `poetry` and it takes all
the hassle out of everything.

To install it [go here](https://python-poetry.org/docs/master/#installing-with-the-official-installer) and run the command.

## Starting A Project

Now we have `poetry` installed we can create the base for our project:

```bash
poetry new --name hello --src helloworld
```

This will create a `helloworld` dir, with the following contents:
```bash
helloworld
├── README.rst
├── pyproject.toml
├── src
│   └── hello
│       └── __init__.py
└── tests
    ├── __init__.py
    └── test_hello.py
```

### Adding Dependencies

Since we know we are going to be using `click` & lets tell `poetry` to
add it:

```bash
cd helloworld
poetry add click
```

### Adding an Entry Point

Back in the day we would use a `setup.py` file to do this, but again `poetry`
does all the hard work for us. We need to add a `tool.poetry.scripts` setting to our
`pyproject.toml`

```
[tool.poetry.scripts]
hello = "src.hello.main:cli"
```
- `hello` = The name of the cli when we run it.
- `src.hello.` = The name of the package
- `main` = The name of the module
- `cli` = The name of the function

### Adding the code

Since we do not have any of the code needed above, `poetry` cannot / will not run our cli. Lets fix that,
add the following code to `src/hello/main.py`
```python
import click
import logging

LOGGING_LEVELS = {
    0: logging.NOTSET,
    1: logging.ERROR,
    2: logging.WARN,
    3: logging.INFO,
    4: logging.DEBUG,
}  #: a mapping of `verbose` option counts to logging levels


# Create the config object
class Config(object):
    def __init__(self) -> None:
        self.verbose: int = 0

# Create the decorator to pass the config object down
pass_config = click.make_pass_decorator(Config, ensure=True)


@click.group()
@click.option("--verbose", "-v", count=True, help="Enable verbose output, (up to -vvvv)")
@pass_config
def cli(config, verbose):
    """Run the cli """
    # Use the verbosity count to determine the logging level...
    if verbose > 0:
        logging.basicConfig(
            level=LOGGING_LEVELS[verbose]
            if verbose in LOGGING_LEVELS
            else logging.DEBUG
        )
        click.echo(
            click.style(
                f"Verbose logging is enabled. "
                f"(LEVEL={logging.getLogger().getEffectiveLevel()})",
                fg="yellow",
            )
        )
    config.verbose = verbose

@cli.command()
@click.option("--string", default="World", help="The name you wish to greet")
@click.option("--repeat", default=1, help="The times you wish to say the greeting")
@click.argument('out', type=click.File('w'), default='-', required=False)
@pass_config
def say(config, string, repeat, out):
    """
    This greets you.
    Args:
    out - This defaults to STDOUT, if given a file will write the greeting to
    that file instead
    """
    if config.verbose in range(1, 5):
        click.echo("ERROR LEVEL")
    if config.verbose in range(2, 5):
        click.echo("WARN LEVEL")
    if config.verbose == 4:
        click.echo("DEBUG LEVEL")
    for _ in range(repeat):
        click.echo(f"Hello {string}!", file=out)

if __name__ == '__main__':
    cli()
```

## Running the script

Now if we run `poetry run hello` we should see this:

```
Usage: hello [OPTIONS] COMMAND [ARGS]...

  Run the cli

Options:
  -v, --verbose  Enable verbose output
  --help         Show this message and exit.

Commands:
  say  This greets you.
```

Or this `poetry run hello say --string foo --repeat 4`:
```
Hello foo!
Hello foo!
Hello foo!
Hello foo!
```

## Saving to Git

Now that we have the boiler plate setup, its a good time to commit to git.

```
git init
git add *
git commit -m "First commit"
git branch -M main
git remote add origin <your git url>
git push -u origin main
```

### Pre-commit Hooks

Add it as a dependency:

```bash
poetry add pre-commit
```

Don't forget to update git!

```
git add poetry.lock pyproject.toml
git commit -m "Add pre-commit dependency."
```

This is my basic `.pre-commit-config.yaml` file:

```yaml
repos:
    - repo: https://github.com/psf/black
      rev: 19.10b0
      hooks:
        - id: black
    - repo: https://github.com/pre-commit/pre-commit-hooks
      rev: v2.5.0
      hooks:
        - id: check-added-large-files
    - repo: local
      hooks:
        - id: pylint
          name: pylint
          entry: poetry run pylint src/
          language: system
          always_run: true
          pass_filenames: false
```

We need to init the hooks:
```
poetry run pre-commit install
```

Once we have init'd the pre-commit hooks will run when we commit code.
[For more info on pre-commit click here](https://pre-commit.com/)


## Uploading the package
Lets say you have built your cli tool and want to upload it to [PyPi](https://pypi.org/)!


We should really test it before pushing to the prod [PyPi](https://pypi.org/) right?
### Testing Upload

First lets configure `poetry` so its aware of the test PyPi repo:
```
poetry config repositories.testpypi https://test.pypi.org/legacy/
```

Create an account on [TestPyPI](https://test.pypi.org/) and then create a new API key under your account settings.

Once you have the key:

```bash
poetry config http-basic.testpypi __token__ <API KEY>
```

To upload you run:

```
poetry build
poetry publish -r testpypi
```

{{< admonition type=tip title="Tip" open=true >}}
You can add `dist` to your `.gitignore` file
{{< /admonition >}}


# References
- [How to create a Python package in 2022](https://mathspp.com/blog/how-to-create-a-python-package-in-2022) - Rodrigo Girão Serrão
- [Build and Test a Command Line Interface with Python, Poetry, Click, and pytest ](https://dev.to/bowmanjd/build-a-command-line-interface-with-python-poetry-and-click-1f5k) - Jonathan Bowman


### Real Upload

- Configure PyPI

Get your API key for [PyPi](https://pypi.org/)

```
poetry config pypi-token.pypi <API KEY>
```

```
poetry publish --build
```

