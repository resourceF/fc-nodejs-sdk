TESTS = test/*.test.js
REPORTER = spec
TIMEOUT = 60000
PATH := ./node_modules/.bin:$(PATH)

lint:
	@eslint --fix lib index.js test

test/figures/test.zip: test/figures/main.js
	@zip -r $@ -j test/figures/main.js

figures: test/figures/test.zip
	@unzip -v $^

test: figures
	@mocha -t $(TIMEOUT) -R spec $(TESTS)

test-es5: figures
	@mocha --compilers js:babel-register -t $(TIMEOUT) -R spec $(TESTS)

test-cov: figures
	@nyc --reporter=html --reporter=text mocha -t $(TIMEOUT) -R spec $(TESTS)

test-coveralls: lint figures
	@nyc mocha -t $(TIMEOUT) -R spec $(TESTS)
	@echo TRAVIS_JOB_ID $(TRAVIS_JOB_ID)
	@nyc report --reporter=text-lcov | coveralls

build-es5:
	@npm run build-es5

doc:
	@doxmate build

.PHONY: test test-es5 doc
