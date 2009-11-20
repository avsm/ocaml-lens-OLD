.PHONY: all test clean
all:
	@cd lib && $(MAKE) all
	@cd parser && $(MAKE) all

test: all
	@cd lib_test && $(MAKE)
	@cd parser_test && $(MAKE)

clean:
	@cd lib && $(MAKE) clean
	@cd parser && $(MAKE) clean
	@cd lib_test && $(MAKE) clean
	@cd parser_test && $(MAKE) clean
