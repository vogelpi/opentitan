# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

NAME=csrng_seed
FLAGS=-Wall -O2 -g

all:
	@for f in $(NAME) ; do \
		gcc $(FLAGS) ../../aes/model/crypto.c ../../aes/model/aes.c $${f}.c -o $${f} -lcrypto -lpthread ; \
	done

clean:
	rm -f $(NAME)
