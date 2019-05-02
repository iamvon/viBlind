#!/usr/bin/env python3
# Copyright 2017-present, Facebook, Inc.
# All rights reserved.
#
# This source code is licensed under the license found in the
# LICENSE file in the root directory of this source tree.

from setuptools import setup, find_packages
import sys

setup(
    name='drqa',
    version='0.1.0',
    description='Reading Wikipedia to Answer Open-Domain Questions',
    python_requires='>=3.5',
    packages=find_packages(exclude=('data')),
)
