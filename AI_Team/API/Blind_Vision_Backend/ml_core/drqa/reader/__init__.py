#!/usr/bin/env python3
# Copyright 2017-present, Facebook, Inc.
# All rights reserved.
#
# This source code is licensed under the license found in the
# LICENSE file in the root directory of this source tree.

import os
from ..tokenizers import CoreNLPTokenizer
from .. import DATA_DIR


DEFAULTS = {
    'tokenizer': CoreNLPTokenizer,
    'model': '/home/tung/bang/Blind_Vision_Backend/ml_core/drqa/reader/single.mdl'
}


def set_default(key, value):
    global DEFAULTS
    DEFAULTS[key] = value

from .model import DocReader
from .predictor import Predictor
from . import config
from . import vector
from . import data
from . import utils
