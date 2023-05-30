PYTHON_EXE?=python3
VENV=venv
ACTIVATE?=. ${VENV}/bin/activate;
VIRTUALENV_PYZ=etc/third_party/virtualenv.pyz

all: virtualenv
	@echo "-> Install dependencies"
	@${ACTIVATE} pip install -e . -c requirements.txt

virtualenv:
	@echo "-> Bootstrap the virtualenv with PYTHON_EXE=${PYTHON_EXE}"
	@${PYTHON_EXE} ${VIRTUALENV_PYZ} --never-download --no-periodic-update ${VENV}

dev: virtualenv
	@echo "-> Configure and install development dependencies"
	@${ACTIVATE} pip install -e .[dev] -c requirements.txt

isort:
	@echo "-> Apply isort changes to ensure proper imports ordering"
	${VENV}/bin/isort .

black:
	@echo "-> Apply black code formatter"
	${VENV}/bin/black .

valid: isort black

check:
	@echo "-> Run pycodestyle (PEP8) validation"
	@${ACTIVATE} pycodestyle --max-line-length=100 --exclude=venv,third_party .
	@echo "-> Run isort imports ordering validation"
	@${ACTIVATE} isort --check-only .
	@echo "-> Run black validation"
	@${ACTIVATE} black --check ${BLACK_ARGS}

clean:
	@echo "-> Clean the Python env"
	rm -rf ${VENV}
	find . -type f -name '*.py[co]' -delete -o -type d -name __pycache__ -delete

debug:
	flask run --debug

run:
	${ACTIVATE} gunicorn purl_fyi:app -u nobody -g nogroup --bind :8000 --timeout 600 --workers 8""
