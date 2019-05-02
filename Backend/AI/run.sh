#!/bin/bash
cd ml_core/question_answering/

python3 setup.py develop

cd ../..

cd server/

export FLASK_APP=api.py

flask run --host=0.0.0.0
