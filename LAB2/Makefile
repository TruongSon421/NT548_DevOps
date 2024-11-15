install:
	pip install --upgrade pip &&\
		pip install -r requirements.txt

test:
	python -m pytest -vv multi_test.py

format:	
	black *.py 

lint:
	pylint --disable=R,C,no-member --ignore-patterns=multi_test.py *.py

container-lint:
	docker run --rm -i hadolint/hadolint < Dockerfile

refactor: format lint

deploy:
	#deploy goes here
		
all: install lint test format deploy